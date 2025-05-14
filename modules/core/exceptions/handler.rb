# frozen_string_literal: true

module Core
  module Exceptions
    # The Handler module provides a centralized mechanism for handling exceptions
    # in the application. It includes methods to handle specific exceptions such as
    # validation errors, missing parameters, and record not found errors, as well as
    # a fallback for internal server errors.
    module Handler
      extend ActiveSupport::Concern

      included do
        # Automatically rescues from StandardError and delegates to the handle_exception method.
        rescue_from StandardError, with: :handle_exception
      end

      private

      # Handles exceptions by delegating to specific methods based on the exception type.
      #
      # @param exception [Exception] The exception to handle.
      def handle_exception(exception)
        case exception
        when ActiveRecord::RecordInvalid
          handle_record_invalid_exception(exception)
        when ActiveRecord::RecordNotFound
          handle_not_found_exception(exception)
        when ActionController::ParameterMissing
          handle_parameter_missing_exception(exception)
        else
          handle_internal_error(exception)
        end
      end

      # Handles ActiveRecord validation errors (HTTP 422).
      #
      # @param exception [ActiveRecord::RecordInvalid] The exception containing validation errors.
      def handle_record_invalid_exception(exception)
        record = Core::Errors::ActiveRecordValidation.new(exception.record)
        errors = record.to_hash

        messages = errors.map { |e| e[:message] }
        first_two = messages.first(2)
        summary = if messages.size > 2
                    "#{first_two.join(', ')} + more"
                  else
                    first_two.join(', ')
                  end

        message = "Validation failed: #{summary}"

        render_error(
          error_code: error_code_for(:unprocessable_entity),
          errors: errors,
          message: message,
          status: :unprocessable_entity
        )
      end

      # Handles record not found errors (HTTP 404).
      #
      # @param exception [ActiveRecord::RecordNotFound] The exception indicating a missing record.
      def handle_not_found_exception(exception)
        render_error(
          message: exception.message || "Resource not found.",
          error_code: error_code_for(:not_found),
          status: :not_found
        )
      end

      # Handles missing parameter errors (HTTP 422).
      #
      # @param exception [ActionController::ParameterMissing] The exception indicating a missing parameter.
      def handle_parameter_missing_exception(exception)
        codes = Core::Config.config[:codes]
        codes = codes[:blank] || codes[:default]
        render_error(
          message: exception.message,
          errors: [
            code: codes,
            filed: exception.param,
            message: "#{exception.param} is required"
          ],
          error_code: error_code_for(:unprocessable_entity),
          status: :unprocessable_entity
        )
      end

      # Handles internal server errors (HTTP 500).
      #
      # @param exception [Exception] The exception causing the internal server error.
      def handle_internal_error(exception)
        logger.error "[InternalError] #{exception.class} - #{exception.message}"
        logger.error exception.backtrace.join("\n") if exception.backtrace

        render_error(
          message: exception.message,
          error_code: error_code_for(:internal_server_error),
          status: :internal_server_error
        )
      end

      # Generates an error code based on the application code and HTTP status.
      #
      # @param status_symbol [Symbol] The HTTP status symbol (e.g., :not_found, :unprocessable_entity).
      # @return [String] The generated error code in the format APP_CODE-STATUS.
      def error_code_for(status_symbol)
        app_code = Core::Config.config[:app_code] rescue "APP"
        status = Rack::Utils.status_code(status_symbol)
        "#{app_code}-#{status}"
      end
    end
  end
end