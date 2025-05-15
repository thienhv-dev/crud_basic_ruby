# This module defines a transformer class within a modular application structure.
# It is designed to handle the transformation of data into a specific format.

module Category
  module Transformers
    # The ListResourceTransformer class provides a method
    # to transform data objects into a hash format.
    class ListResource
      # Transforms the given data object into a hash.
      #
      # @param data [Object] The data object to be transformed.
      # @return [Hash] A hash representation of the transformed data.
      def self.transform(data)
        {
          id: data.id,
          name: data.name,
          description: data.description,
        }
      end
    end
  end
end