# frozen_string_literal: true

# This module defines a Rails generator for creating a controller file
# within a modular application structure. It automates the process of
# generating the necessary directory and template file for a module's controller.

module Modular
  class MakeControllerGenerator < Rails::Generators::Base
    # Specifies the source directory for templates used by the generator.
    source_root File.expand_path("templates", __dir__)

    # Defines an argument for the generator.
    # @param name [String] The name of the controller to be generated (e.g., UsersController).
    argument :name, type: :string, desc: "Name of the controller (e.g., UsersController)"

    # Defines an argument for the generator.
    # @param module_name [String] The name of the module for which the controller will be generated (e.g., User).
    argument :module_name, type: :string, desc: "Name of the module (e.g., User)"

    # Provides a description of the generator's purpose.
    desc "Generate Controller for a module"

    # Creates the controller file for the specified module and controller name.
    # This method generates the target directory and populates it with a template file.
    def create_controller_file
      # Defines the target directory for the controller file.
      target_path = File.join("modules", module_name.underscore, "http", "controllers")

      # Creates the target directory if it does not exist.
      empty_directory target_path

      # Defines the full path for the controller file.
      path = File.join(target_path, "#{name.underscore}.rb")

      # Copies the template file to the target path, replacing placeholders with actual values.
      template "controller.rb.tt", path
    end
  end
end