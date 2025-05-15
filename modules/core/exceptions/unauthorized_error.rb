# This module defines a custom exception class for handling unauthorized access errors.
# It is part of the Core::Exceptions namespace and inherits from the StandardError class.

module Core
  module Exceptions
    # The UnauthorizedError class represents an error raised when a user attempts
    # to perform an action without proper authentication or authorization.
    class UnauthorizedError < StandardError; end
  end
end