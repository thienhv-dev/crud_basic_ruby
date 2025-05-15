# This module defines a transformer class within a modular application structure.
# It is designed to handle the transformation of data into a specific format.

module Auth
  module Transformers
    # The ProfileResource class provides a method
    # to transform data objects into a hash format.
    class ProfileResource
      # Transforms the given data object into a hash.
      #
      # @param data [Object] The data object to be transformed.
      # @return [Hash] A hash representation of the transformed data.
      def self.transform(data)
        {
          id: data.id,
          email: data.email,
          created_at: data.created_at,
        }
      end
    end
  end
end