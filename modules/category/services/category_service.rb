# This module defines a service class within a modular application structure.
# It is designed to encapsulate business logic and interact with a repository.

module Category
  module Services
    # The CategoryService class provides a service layer for handling
    # business logic and delegating database operations to a repository.
    class CategoryService
      # Initializes the service with a repository instance.
      # The repository is responsible for interacting with the database.
      def initialize(category_repository = Category::Repositories::CategoryRepository.new)
        @category_repository = category_repository
      end

      # Retrieves a paginated list of categories from the repository.
      # Optionally filters the categories based on a search query.
      #
      # @param page [Integer] The page number for pagination.
      # @param limit [Integer] The number of records per page.
      # @param search [String, nil] Optional search query to filter categories.
      # @return [ActiveRecord::Relation] A paginated collection of categories.
      def list(page:, limit:, search: nil)
        @category_repository.get_list(page: page, limit: limit, search: search)
      end

      # Finds a category by its ID.
      #
      # @param id [Integer] The ID of the category to find.
      # @return [ActiveRecord::Base] The found category.
      # @raise [ActiveRecord::RecordNotFound] If no category is found with the given ID.
      def find(id)
        @category_repository.find(id)
      end

      # Creates a new category with the given parameters.
      #
      # @param params [Hash] The attributes for the new category.
      # @return [ActiveRecord::Base] The created category.
      def create(params)
        @category_repository.create(params)
      end

      # Updates an existing category with the given parameters.
      #
      # @param id [Integer] The ID of the category to update.
      # @param params [Hash] The attributes to update the category with.
      # @return [ActiveRecord::Base] The updated category.
      # @raise [ActiveRecord::RecordNotFound] If no category is found with the given ID.
      def update(id, params)
        category = find(id)
        category.update(params)
        category
      end

      # Deletes a category by its ID.
      #
      # @param id [Integer] The ID of the category to delete.
      # @return [void]
      def delete(id)
        category = find(id)
        category.destroy
      end
    end
  end
end