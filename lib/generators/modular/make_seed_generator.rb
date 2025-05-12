# frozen_string_literal: true

# This module defines a Rails generator for creating seed files
# within a modular application structure. It automates the process of
# generating the necessary directory and template file for a module's seed data.
# Usage: rails g modular:make_seed FileName ModelName
module Modular
  class MakeSeedGenerator < Rails::Generators::Base
    # Specifies the source directory for templates used by the generator.
    source_root File.expand_path("templates", __dir__)

    # Defines two arguments for the generator.
    # @param file_name [String] The name of the seed file (e.g., 'ABC').
    # @param model_name [String] The name of the model (e.g., 'ModuleName').
    argument :file_name, type: :string
    argument :model_name, type: :string

    # Provides a description of the generator's purpose.
    desc "Generate a seed file for the module with the specified file name and model name"

    # Creates the seed file for the specified module and file name.
    # This method generates the target directory and populates it with a template file.
    def create_seed_file
      # Defines the target directory for the seed file.
      target_path = "modules/#{model_name.underscore}/database/seeds"

      # Creates the target directory if it does not exist.
      empty_directory target_path

      # Defines the name of the seed file to be generated.
      seed_file_name = "#{file_name.underscore}_seeds.rb"

      # Generates the seed file based on the template, passing the model_name and file_name.
      template "seeds.rb.tt", File.join(target_path, seed_file_name)
    end
  end
end