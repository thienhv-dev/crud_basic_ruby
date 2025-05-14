module Core
  module Errors
    # This class is responsible for handling ActiveRecord validation errors.
    # It serializes the validation errors into a standardized format for API responses.
    class ActiveRecordValidation
      # @return [Object] The ActiveRecord object that contains validation errors.
      attr_reader :record

      # Initializes a new instance of ActiveRecordValidation.
      #
      # @param record [Object] The ActiveRecord object with validation errors.
      def initialize(record)
        @record = record
        @errors = serialize
      end

      # Serializes the validation errors into a structured format.
      #
      # @param full_messages [Boolean] Whether to include full error messages.
      # @return [Array<Hash>] An array of serialized error hashes.
      def serialize(full_messages: true)
        # Converts the validation error messages into a hash.
        messages = record.errors.to_hash full_messages

        # Maps each field and its error details to a serialized error structure.
        record.errors.details.map do |field, details|
          detail = details.first[:error]
          message = messages[field].first
          Core::Serializers::ValidationErrorSerializer.new(record, field, detail, message).serialize
        end
      end

      # Converts the serialized errors into a hash format.
      #
      # @return [Array<Hash>] An array of serialized error hashes.
      def to_hash
        serialize
      end
    end
  end
end