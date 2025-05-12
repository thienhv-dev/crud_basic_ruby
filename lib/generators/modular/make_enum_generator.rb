# frozen_string_literal: true

# This module defines a Rails generator for creating an enumeration class
# within a modular application structure. It automates the process of
# generating the necessary directory and template file for a module's enumeration.
# Usage: rails g modular:make_enum EnumName ModuleName
module Modular
  class MakeEnumGenerator < Rails::Generators::Base
    # Specifies the source directory for templates used by the generator.
    source_root File.expand_path("templates", __dir__)

    # Defines an argument for the generator.
    # @param enum_name [String] The name of the enum class to be generated.
    # @param module_name [String] The name of the module for which the enum will be generated.
    argument :enum_name, type: :string, desc: "Name of the enum class"
    argument :module_name, type: :string, desc: "Name of the module"

    # Provides a description of the generator's purpose.
    desc "Generate Enum of module"

    # Creates the enum file for the specified module and enum name.
    # This method generates the target directory and populates it with a template file.
    def create_enum_file
      # Defines the target path for the enum file.
      target_path = File.join("modules", module_name.underscore, "enums")

      # Creates an empty directory at the target path if it does not already exist.
      empty_directory(target_path)

      # Sets instance variables for use in the template.
      @module_name = module_name.camelize
      @enum_name = enum_name.camelize

      # Copies the template file to the target path, replacing placeholders with actual values.
      template("enum.rb.tt", File.join(target_path, "#{enum_name.underscore}.rb"))
    end
  end
end