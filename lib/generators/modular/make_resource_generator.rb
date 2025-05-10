# frozen_string_literal: true

# This module defines a Rails generator for creating a transformer class
# within a modular application structure. It automates the process of
# generating the necessary directory and template file for a module's transformer.
# Usage: rails g modular:make_resource ResourceName ModuleName
module Modular
  class MakeResourceGenerator < Rails::Generators::Base
    # Specifies the source directory for templates used by the generator.
    source_root File.expand_path("templates", __dir__)

    # Defines arguments for the generator.
    # @param resource_name [String] The name of the resource for which the transformer will be generated.
    # @param module_name [String] The name of the module for which the resource belongs.
    argument :resource_name, type: :string
    argument :module_name, type: :string

    # Provides a description of the generator's purpose.
    desc "Generate Transformers of module"

    # Creates the transformer file for the specified module and resource name.
    # This method generates the target directory and populates it with a template file.
    def create_transformer_file
      # Sets instance variables for use in the template.
      @module_name = module_name
      @resource_name = resource_name

      # Defines the target directory for the transformer file.
      target_path = File.join("modules", @module_name.underscore, "transformers")

      # Creates the target directory if it doesn't exist.
      empty_directory target_path

      # Copies the template file to the target path, replacing placeholders with actual values.
      template "transformer.rb.tt", File.join(target_path, "#{@resource_name.underscore}.rb")
    end
  end
end