module Core
  module Http
    module Controllers
      # BaseController serves as the base class for all HTTP controllers in the Core module.
      # It inherits from ActionController::API, providing a lightweight framework for building APIs.
      # This controller includes modules for handling API responses and exceptions.
      class BaseController < ActionController::API
        # Includes the ResponseHandler module to standardize API responses.
        include Core::Transformers::ResponseHandler

        # Includes the Core::Exceptions::Handler module to handle exceptions
        # and provide consistent error responses for the API.
        include Core::Exceptions::Handler
      end
    end
  end
end