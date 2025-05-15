# frozen_string_literal: true

# The ResponseHandler module provides methods to standardize API responses.
# It includes methods for rendering success responses with optional pagination
# and error responses with detailed error information.
require_relative '../../../modules/core/config/config'

module Core
  module Transformers
    module ResponseHandler
      extend ActiveSupport::Concern

      # Renders a success response in JSON format.
      # If the data supports pagination, it includes pagination details in the response.
      #
      # @param data [Object] The data to be rendered in the response. Can be a paginated collection or any object.
      # @param status [Symbol] The HTTP status for the response (default: :ok).
      def render_success(data = {}, status: :ok, transformed_data: nil)
        if paginated?(data)
          render json: {
            data: transformed_data || extract_data(data),
            pagination: build_pagination(data)
          }, status: status
        else
          render json: {
            data: data
          }, status: status
        end
      end

      # Renders a success response with a custom message in JSON format.
      #
      # @param message [String] The custom success message to include in the response (default: "OK").
      def render_success_with_message(message = 'OK')
        render json: {
          data: {
            message: message,
            code: 'OK'
          }
        }, status: :ok
      end

      # Renders an error response in JSON format.
      #
      # @param message [String] A human-readable error message (default: "ERROR").
      # @param error_code [String, nil] A custom error code (default: generated from app code and HTTP status).
      # @param errors [Array] An array of detailed error objects (default: empty array).
      # @param status [Symbol] The HTTP status for the response (default: :unprocessable_entity).
      def render_error(message: "ERROR", error_code: nil, errors: [], status: :unprocessable_entity)
        render json: {
          error: {
            status_code: Rack::Utils.status_code(status),
            code: Rack::Utils::HTTP_STATUS_CODES[Rack::Utils.status_code(status)],
            message: message,
            error_code: error_code || "#{Core::Config.config[:app_code]}-#{Rack::Utils.status_code(status)}",
            errors: errors
          }
        }, status: status
      end

      private

      # Constructs a URL with the specified page number for pagination.
      #
      # @param base_url [String] The base URL of the request.
      # @param query_params [Hash] The query parameters for the request.
      # @param page [Integer] The page number to include in the URL.
      # @return [String] The constructed URL with the page parameter.
      def url_with_page(base_url, query_params, page)
        query_string = query_params.merge(page: page).to_query
        "#{base_url}?#{query_string}"
      end

      # Checks if the given data supports pagination by verifying if it responds to
      # `as_json` and `current_page` methods.
      #
      # @param data [Object] The data to check for pagination support.
      # @return [Boolean] True if the data supports pagination, false otherwise.
      def paginated?(data)
        data.respond_to?(:as_json) && data.respond_to?(:current_page)
      end

      # Extracts the data to be rendered in the response.
      # If the data supports pagination, it returns the data as is.
      # Otherwise, it returns transformed data or the original data.
      #
      # @param data [Object] The data to extract.
      # @return [Object] The extracted data.
      def extract_data(data)
        return data if paginated?(data)
        @transformed_data || data
      end

      # Builds a pagination metadata hash for the given paginated data.
      # Includes details such as current page, total pages, per-page count,
      # and URLs for navigation between pages.
      #
      # @param paginated [Object] The paginated data object.
      # @return [Hash] A hash containing pagination metadata.
      def build_pagination(paginated)
        base_url = request.base_url + request.path
        query_params = request.query_parameters.except(:page)

        current_page = paginated.current_page
        total_pages = paginated.total_pages
        per_page = paginated.limit_value
        total_count = paginated.total_count

        {
          current_page: current_page,
          first_page_url: url_with_page(base_url, query_params, 1),
          from: (current_page - 1) * per_page + 1,
          last_page: total_pages,
          last_page_url: url_with_page(base_url, query_params, total_pages),
          next_page_url: (current_page < total_pages) ? url_with_page(base_url, query_params, current_page + 1) : nil,
          path: base_url,
          per_page: per_page,
          prev_page_url: (current_page > 1) ? url_with_page(base_url, query_params, current_page - 1) : nil,
          to: [current_page * per_page, total_count].min,
          total: total_count
        }
      end
    end
  end
end
