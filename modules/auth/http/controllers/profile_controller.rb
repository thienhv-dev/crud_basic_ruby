# This module defines a controller class for handling HTTP requests in a modular structure.
# It is designed to be used as a template for generating new controllers.

module Auth
  module Http
    module Controllers
      # The ProfileController class handles profile-related HTTP requests.
      # It inherits from Core::Http::Controllers::BaseController.
      class ProfileController < Core::Http::Controllers::BaseController
        # Handles the `show` action to retrieve and render the current user's profile.
        #
        # @return [JSON]
        def show
          user = current_user

          render json: {
            data: Auth::Transformers::ProfileResource.transform(user)
          }
        end
      end
    end
  end
end