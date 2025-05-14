# This module defines the structure for an entity model within a modular application.
# It is designed to be used as a template for generating new models.

module User
  module Entities
    # The User class inherits from ApplicationRecord
    # and represents a database-backed entity in the application.
    class User < ApplicationRecord
      include Devise::JWT::RevocationStrategies::JTIMatcher
      # Include default devise modules. Others available are:
      # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
      devise :database_authenticatable, :registerable,
             :recoverable, :rememberable, :validatable,
             :jwt_authenticatable, jwt_revocation_strategy: self
    end
  end
end