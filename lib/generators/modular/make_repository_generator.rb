# frozen_string_literal: true

# This module defines a Rails generator for creating a repository class
# within a modular application structure. It automates the process of
# generating the necessary directory and template file for a module's repository.
# Usage: rails g modular:make_repository RepositoryName ModuleName [--model=ModelName]
module Modular
  module Generators
    class MakeRepositoryGenerator < Rails::Generators::NamedBase
      # Specifies the source directory for templates used by the generator.
      source_root File.expand_path('templates', __dir__)

      # Defines an argument for the generator.
      # @param module_name [String] The name of the module for which the repository will be generated.
      argument :module_name, type: :string

      # Defines an optional flag for the generator.
      # @option model [String] The name of the model to bind the repository with. Defaults to "BaseModel".
      class_option :model, type: :string, default: nil, desc: "Model to bind repository with"

      # Creates the repository file for the specified module and repository name.
      # This method generates the target directory and populates it with a template file.
      def create_repository_file
        # Sets instance variables for use in the template.
        @repository_name = name
        @model_name = options[:model] || "BaseModel"
        @module_name = module_name

        # Defines the target directory for the repository file.
        target_path = File.join("modules", @module_name.underscore, "repositories")

        # Creates an empty directory at the target path if it does not already exist.
        empty_directory target_path

        # Copies the template file to the target path, replacing placeholders with actual values.
        template "repository.rb.tt", File.join(target_path, "#{@repository_name.underscore}.rb")
      end
    end
  end
end