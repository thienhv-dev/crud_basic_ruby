# This module defines the structure for an entity model within a modular application.
# It is designed to be used as a template for generating new models.

module Category
  module Entities
    # The Category class inherits from ApplicationRecord
    # and represents a database-backed entity in the application.
    class Category < ApplicationRecord
      validates :name, presence: true, length: { maximum: 100 }
      validates :description, presence: true, length: { maximum: 255 }
    end
  end
end