# This Rake task defines a namespace for seeding data in a modular Rails application.
# It provides a task to run seed files for specific modules, ensuring modularity
# and flexibility in managing seed data.

namespace :db do
  namespace :seed do
    # Provides a description for the `run` task, explaining its purpose and usage.
    # Usage: `rails db:seed:run[ModuleName]`
    # @param module_name [String] The name of the module for which the seed file should be executed.
    desc "Run module seed. Example: rails db:seed:run[Category]"

    # Defines the `run` task, which executes the seed file for the specified module.
    # This task requires the Rails environment to be loaded.
    task :run, [:module_name] => :environment do |_, args|
      # Checks if the module name argument is provided.
      # If not, outputs an error message and exits the task.
      if args[:module_name].nil?
        puts "Please provide a module name. Example: rails db:seed:run[Category]"
        next
      end

      # Converts the provided module name to an underscored format.
      module_name = args[:module_name].underscore

      # Constructs the path to the seed file for the specified module.
      seed_file = Rails.root.join("modules", module_name, "database", "seeds", "#{module_name}_seeds.rb")

      # Checks if the seed file exists at the constructed path.
      if File.exist?(seed_file)
        # If the seed file exists, outputs a message and executes the file.
        puts "Running seed from #{seed_file}"
        load seed_file
      else
        # If the seed file does not exist, outputs an error message.
        puts "Seed file not found: #{seed_file}"
      end
    end
  end
end