# frozen_string_literal: true

# This module defines a Rails generator for creating a service class
# within a modular application structure. It automates the process of
# generating the necessary directory and template file for a module's service.
# Usage: rails g modular:make_service ServiceName ModelName [--with_base_repository]
module Modular
  class MakeServiceGenerator < Rails::Generators::Base
    # Specifies the source directory for templates used by the generator.
    source_root File.expand_path('templates', __dir__)

    # Defines arguments for the generator.
    # @param service_name [String] The name of the service to be generated.
    # @param model_name [String] The name of the model associated with the service.
    argument :service_name, type: :string
    argument :model_name, type: :string

    # Defines an optional flag for the generator.
    # @option with_base_repository [Boolean] Whether to include a base repository in the service. Defaults to false.
    class_option :with_base_repository, type: :boolean, default: false

    # Provides a description of the generator's purpose.
    desc "Generate Service of module"

    # Creates the service file for the specified module and service name.
    # This method generates the target directory and populates it with a template file.
    def create_service_file
      # Sets instance variables for use in the template.
      @module_name = model_name
      @service_name = service_name
      @repository_name = "#{model_name.underscore}_repository"

      # Defines the target directory for the service file.
      target_path = File.join("modules", @module_name.underscore, "services")

      # Creates the target directory if it doesn't exist.
      empty_directory target_path

      # Copies the template file to the target path, replacing placeholders with actual values.
      template "service.rb.tt", File.join(target_path, "#{@service_name.underscore}.rb")
    end
  end
end