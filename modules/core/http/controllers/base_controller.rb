module Core
  module Http
    module Controllers
      # BaseController serves as the base class for all HTTP controllers in the Core module.
      # It inherits from ActionController::API, providing a lightweight framework for building APIs.
      # This controller includes modules for handling API responses and exceptions.
      class BaseController < ActionController::API
        # Executes the specified callback before processing controller actions.
        # In this case, it ensures that the user is authenticated before any action is executed.
        before_action :authenticate_user!

        # Includes the ResponseHandler module to standardize API responses.
        include Core::Transformers::ResponseHandler

        # Includes the Core::Exceptions::Handler module to handle exceptions
        # and provide consistent error responses for the API.
        include Core::Exceptions::Handler

        private

        # Authenticates the current user before processing a request.
        # If no user is authenticated, it raises an UnauthorizedError with a relevant message.
        #
        # @raise [Core::Exceptions::UnauthorizedError] If the current user is not authenticated.
        def authenticate_user!
          unless current_user
            raise Core::Exceptions::UnauthorizedError, 'These credentials do not match our records.'
          end
        end
      end
    end
  end
end