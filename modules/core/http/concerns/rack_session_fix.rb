module Core
  module Http
    module Concerns
      # This module is designed to fix the issue with Rack session in Rails applications.
      # It ensures that the session is properly managed and does not interfere with the request/response cycle.
      module RackSessionFix
        extend ActiveSupport::Concern

        # A fake Rack session class that inherits from Hash.
        # This class is used to simulate a Rack session and includes a method to indicate
        # that the session is not enabled.
        class FakeRackSession < Hash
          # Indicates whether the session is enabled.
          #
          # @return [Boolean] Always returns false, indicating the session is not enabled.
          def enabled?
            false
          end
        end

        included do
          # Sets a fake Rack session for Devise before processing any controller action.
          before_action :set_fake_rack_session_for_devise

          private

          # Ensures that the `rack.session` key in the request environment is set to a fake session.
          # This prevents issues with session management in certain scenarios, such as when using Devise.
          #
          # @return [void]
          def set_fake_rack_session_for_devise
            request.env['rack.session'] ||= FakeRackSession.new
          end
        end
      end
    end
  end
end