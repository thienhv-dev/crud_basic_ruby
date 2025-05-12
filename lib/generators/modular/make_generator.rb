# frozen_string_literal: true

# This module defines a Rails generator for creating a module with all its components
# within a modular application structure. It automates the process of generating
# configuration, routes, models, repositories, services, and controllers for a module.
# Usage: rails g modular:make ModuleName [--api]
module Modular
  class MakeGenerator < Rails::Generators::Base
    # Specifies the source directory for templates used by the generator.
    source_root File.expand_path('templates', __dir__)

    # Defines an argument for the generator.
    # @param module_name [String] The name of the module to be created.
    argument :module_name, type: :string, required: true, desc: "Name of the module to be created"

    # Defines an optional flag for the generator.
    # @option api [Boolean] Whether to generate API routes for the module.
    class_option :api, type: :boolean, default: false, desc: "Generate API routes"

    # Creates all necessary files for the specified module.
    # This method invokes other generators to create configuration, routes, models,
    # repositories, services, and controllers for the module.
    def create_module_files
      # Outputs a message indicating the module being created.
      say("Creating module: #{module_name.camelize}", :green)

      # Generates the configuration file for the module.
      generate "modular:make_config", "#{module_name} #{module_name}"

      # Generates the route file for the module.
      generate "modular:make_route", "#{module_name} #{module_name}"

      # Generates the model file for the module.
      generate "modular:make_model", "#{module_name} #{module_name}"

      # Generates the repository file for the module.
      generate "modular:make_repository", "#{module_name}_repository #{module_name} --model=#{module_name}::Entities::#{module_name}"

      # Generates the service file for the module, including a base repository if specified.
      generate "modular:make_service", "#{module_name.underscore}_service #{module_name} --with-base-repository"

      # Generates the controller file for the module.
      generate "modular:make_controller", "#{module_name}_controller #{module_name}"
    end
  end
end