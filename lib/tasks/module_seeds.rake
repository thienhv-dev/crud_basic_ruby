# This Rake task defines a namespace for seeding data in a modular Rails application.
# It dynamically creates tasks for each module, allowing seed files to be executed
# individually for each module.

namespace :db do
  namespace :seed do
    # Iterates through all module directories in the 'modules' folder.
    Dir[Rails.root.join('modules', '*')].each do |mod_path|
      # Extracts the name of the module directory.
      module_dir_name = File.basename(mod_path)

      # Constructs the expected seed file name for the module.
      seed_file_name = "#{module_dir_name}_seeds.rb"

      # Dynamically creates a namespace for the module's seed task.
      namespace seed_file_name.gsub('.rb', '').to_sym do
        # Provides a description for the seed task.
        desc "Seed data for #{module_dir_name} module"

        # Defines the task to run the seed file for the module.
        task :run => :environment do
          # Constructs the full path to the module's seed file.
          seed_file = File.join(mod_path, 'database', 'seeds', seed_file_name)

          # Checks if the seed file exists and executes it if found.
          if File.exist?(seed_file)
            puts "Running seed for #{module_dir_name} from #{seed_file}"
            load seed_file
          else
            # Outputs a message if no seed file is found for the module.
            puts "No seed file found for #{module_dir_name}"
          end
        end
      end
    end
  end
end