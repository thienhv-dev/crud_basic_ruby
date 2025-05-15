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

        # The `index` action responds with a JSON object containing a message.
        # The message includes the name of the controller and the action.
        #
        # @return [JSON]
        def index
          categories = @category_service.list(
            page: params[:page],
            limit: params[:limit],
            search: params[:search]
          )

          @transformed_data = categories.map { |c| Category::Transformers::ListResource.transform(c) }
          render_success(categories)
        end

        def show
          category = @category_service.find(params[:id])

          render_success(Category::Transformers::DetailResource.transform(category))
        end

        def store
          category = @category_service.create(create_or_update_params)
          category.save!

          render_success(Category::Transformers::DetailResource.transform(category))
        end

        def update
          category = @category_service.update(params[:id], create_or_update_params)

          render_success(Category::Transformers::DetailResource.transform(category))
        end

        def destroy
          @category_service.delete(params[:id])

          render_success_with_message
        end

        private

        def create_or_update_params
          params.require(:category).permit(:name, :description)
        end
      end
    end
  end
end