# frozen_string_literal: true

# This is the seed file for the User module
# It will create some default records for this module

module User
  class Seed
    def self.run
      # Clear existing records to avoid duplicates
      User::Entities::User.delete_all

      # Example seed data for User::Entities::User
      User::Entities::User.create!(
        email: "admin@example.com",
        password: "admin123",
        jti: SecureRandom.uuid
      )

      # Add other seeds for your models as needed
    end
  end
end

# Run the seed data for User module
User::Seed.run
