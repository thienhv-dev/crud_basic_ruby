# This module defines a configuration namespace within a modular application structure.
# It is intended to hold configuration settings and logic for the application.

module Core
  module Config
    def self.config
      {
        app_code: ENV.fetch('APP_CODE', 'RB'),
        codes: {
          default: 1000,
          confirmation: 1001,
          accepted: 1002,
          blank: 1003,
          presence: 1003,
          present: 1004,
          too_short: 1005,
          too_long: 1006,
          wrong_length: 1007,
          taken: 1008,
          invalid: 1009,
          inclusion: 1010,
          exclusion: 1011,
          required: 1012,
          not_a_number: 1013,
          greater_than: 1014,
          greater_than_or_equal_to: 1015,
          equal_to: 1016,
          less_than: 1017,
          less_than_or_equal_to: 1018,
          other_than: 1019,
          not_an_integer: 1020,
          odd: 1021,
          even: 1022,
          record_not_found: 1100
        }
      }
    end
  end
end
