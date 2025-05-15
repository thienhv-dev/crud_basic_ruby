# This module defines a controller class for handling HTTP requests in a modular structure.
# It is designed to be used as a template for generating new controllers.

module Category
  module Http
    module Controllers
      # The CategoryController controller inherits from Core::Http::Controllers::BaseController
      # and provides an `index` action that renders a JSON response.
      class CategoryController < Core::Http::Controllers::BaseController
        def initialize(category_service = Category::Services::CategoryService.new)
          @category_service = category_service
        end

        # The `index` action retrieves a paginated list of categories, optionally filtered by a search query,
        # and renders the result as a JSON response.
        #
        # @return [JSON] A JSON array of transformed category data.
        def index
          categories = @category_service.list(
            page: params[:page],
            limit: params[:limit],
            search: params[:search]
          )

          transformed = categories.map { |c| Category::Transformers::ListResource.transform(c) }

          render_success(categories, transformed_data: transformed)
        end

        # The `show` action retrieves a single category by its ID and renders it as a JSON response.
        #
        # @return [JSON] A JSON object of the transformed category data.
        def show
          category = @category_service.find(params[:id])

          render_success(Category::Transformers::DetailResource.transform(category))
        end

        # The `store` action creates a new category with the provided parameters,
        # saves it to the database, and renders the created category as a JSON response.
        #
        # @return [JSON] A JSON object of the transformed created category data.
        def store
          category = @category_service.create(create_or_update_params)
          category.save!

          render_success(Category::Transformers::DetailResource.transform(category))
        end

        # The `update` action updates an existing category with the provided parameters
        # and renders the updated category as a JSON response.
        #
        # @return [JSON] A JSON object of the transformed updated category data.
        def update
          category = @category_service.update(params[:id], create_or_update_params)

          render_success(Category::Transformers::DetailResource.transform(category))
        end

        # The `destroy` action deletes a category by its ID and renders a success message as a JSON response.
        #
        # @return [JSON] A JSON object containing a success message.
        def destroy
          @category_service.delete(params[:id])

          render_success_with_message
        end

        private

        # Permits and returns the parameters required for creating or updating a category.
        #
        # @return [ActionController::Parameters] The permitted parameters for a category.
        def create_or_update_params
          params.require(:category).permit(:name, :description)
        end
      end
    end
  end
end