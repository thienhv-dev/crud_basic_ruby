# This module defines a repository class for interacting with an ActiveRecord model.
# It is designed to encapsulate database operations for a specific model.

module Category
  module Repositories
    # The CategoryRepository class provides methods to interact with the database
    # using the specified ActiveRecord model.
    class CategoryRepository
      # Initializes the repository with an ActiveRecord model.
      #
      # @param model [Class] ActiveRecord model class, default: Category::Entities::Category
      def initialize(model = Category::Entities::Category)
        @model = model
      end

      # Retrieves a paginated list of records from the database.
      # Optionally filters the records based on a search query.
      #
      # @param page [Integer] The page number for pagination.
      # @param limit [Integer] The number of records per page.
      # @param search [String, nil] Optional search query to filter records by name or description.
      # @return [ActiveRecord::Relation] A paginated collection of records.
      def get_list(page:, limit:, search: nil)
        query = @model

        if search.present?
          query = query.where("name ILIKE :q OR description ILIKE :q", q: "%#{search}%")
        end

        query.page(page).per(limit)
      end

      # Finds a record by its ID.
      #
      # @param id [Integer] The ID of the record to find.
      # @return [ActiveRecord::Base] The found record.
      # @raise [ActiveRecord::RecordNotFound] If no record is found with the given ID.
      def find(id)
        @model.find(id)
      end

      # Creates a new record in the database with the given parameters.
      #
      # @param params
      # @return [ActiveRecord::Base] The created record.
      def create(params)
        @model.create(params)
      end
    end
  end
end