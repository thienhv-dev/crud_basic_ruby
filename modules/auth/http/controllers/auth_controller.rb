# This module defines a controller class for handling HTTP requests in a modular structure.
# It is designed to be used as a template for generating new controllers.

module Auth
  module Http
    module Controllers
      # The AuthController class handles authentication-related HTTP requests.
      # It inherits from Devise::SessionsController and includes several modules
      # for session management, response handling, and exception handling.
      class AuthController < Devise::SessionsController
        # Includes a module to fix Rack session issues in Rails applications.
        include Core::Http::Concerns::RackSessionFix

        # Includes a module to handle and transform responses.
        include Core::Transformers::ResponseHandler

        # Includes a module to handle exceptions in a centralized manner.
        include Core::Exceptions::Handler

        # Specifies that the controller responds to JSON format.
        respond_to :json

        private

        # Responds to a successful authentication request by encoding a JWT token
        # and rendering a success response with the token details.
        #
        # @param resource [Object] The authenticated resource (e.g., user).
        # @param _opts [Hash] Additional options (not used).
        # @return [void]
        def respond_with(resource, _opts = {})
          token, _payload = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil)

          render_success({
            token_type: 'Bearer',
            access_token: token,
            expires_in: Devise::JWT.config.expiration_time
          })
        end

        # Responds to a logout request. Ensures the current user is authenticated
        # before proceeding and renders a success message upon successful logout.
        #
        # @raise [Core::Exceptions::UnauthorizedError] If no user is authenticated.
        # @return [void]
        def respond_to_on_destroy
          raise Core::Exceptions::UnauthorizedError unless current_user

          success_with_message
        end
      end
    end
  end
end