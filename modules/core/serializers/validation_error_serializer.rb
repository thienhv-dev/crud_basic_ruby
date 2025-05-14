# frozen_string_literal: true

module Core
  module Serializers
    # This class is responsible for serializing validation errors for API responses.
    # It formats the error details into a standardized structure with a code, field, and message.
    class ValidationErrorSerializer
      # Initializes a new instance of ValidationErrorSerializer.
      #
      # @param record [Object] The record object that caused the validation error.
      # @param field [Symbol, String] The field name associated with the validation error.
      # @param detail [Symbol, String] The error detail or type (e.g., :blank, :invalid).
      # @param message [String] The human-readable error message.
      def initialize(record, field, detail, message)
        @record = record
        @field = field
        @detail = detail
        @message = message
      end

      # Serializes the validation error into a hash structure.
      #
      # @return [Hash] A hash containing the error code, field, and message.
      def serialize
        {
          code: code,
          field: field,
          message: @message,
        }
      end

      private

      # Translates the field name into a localized string using I18n.
      #
      # @return [String] The localized field name or the original field name as a string.
      def field
        I18n.t @field,
               scope: [:api, :errors, :fields, underscored_resource_name],
               default: @field.to_s
      end

      # Retrieves the error code based on the error detail.
      #
      # @return [String] The error code corresponding to the detail, or a default code if not found.
      def code
        codes = Core::Config.config[:codes]
        codes[@detail.to_sym] || codes[:default]
      end

      # Converts the record's class name into an underscored resource name.
      #
      # @return [String] The underscored name of the record's class.
      def underscored_resource_name
        @record.class.to_s.gsub("::", "").underscore
      end
    end
  end
end