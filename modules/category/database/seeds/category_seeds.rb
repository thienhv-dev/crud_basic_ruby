# frozen_string_literal: true

# This is the seed file for the Category module
# It will create some default records for this module

module Category
  class Seed
    def self.run
      1_000.times do
        Category::Entities::Category.create!(
          name: Faker::Commerce.department(max: 1, fixed_amount: true),
          description: Faker::Lorem.sentence(word_count: 10)
        )
      end
    end
  end
end

# Run the seed data for Category module
Category::Seed.run
