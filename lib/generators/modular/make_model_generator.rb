# frozen_string_literal: true

# This module defines a Rails generator for creating a model class
# within a modular application structure. It automates the process of
# generating the necessary directory and template file for a module's model.
# Usage: rails g modular:make_model ModelName ModuleName
module Modular
  module Generators
    class MakeModelGenerator < Rails::Generators::Base
      # Specifies the source directory for templates used by the generator.
      source_root File.expand_path("templates", __dir__)

      # Defines an argument for the generator.
      # @param model_name [String] The name of the model class to be generated.
      # @param module_name [String] The name of the module for which the model will be generated.
      argument :model_name, type: :string, required: true
      argument :module_name, type: :string, required: true

      # Provides a description of the generator's purpose.
      desc "Generate a model class inside a modular structure"

      # Creates the model file for the specified module and model name.
      # This method generates the target directory and populates it with a template file.
      def create_model_file
        # Defines the target path for the model file.
        target_path = "modules/#{module_name.underscore}/entities"

        # Creates an empty directory at the target path if it does not already exist.
        empty_directory target_path

        # Copies the template file to the target path, replacing placeholders with actual values.
        template "model.rb.tt", File.join(target_path, "#{model_name.underscore}.rb")
      end
    end
  end
end