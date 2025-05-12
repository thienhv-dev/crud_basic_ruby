# frozen_string_literal: true

# This module defines a Rails generator for creating a configuration file
# within a modular application structure. It automates the process of
# generating the necessary directory and template file for a module's configuration.
# Usage: rails g modular:make_config ModuleName
module Modular
  class MakeConfigGenerator < Rails::Generators::Base
    # Specifies the source directory for templates used by the generator.
    source_root File.expand_path("templates", __dir__)

    # Defines an argument for the generator.
    # @param module_name [String] The name of the module for which the configuration file will be generated.
    argument :module_name, type: :string

    # Provides a description of the generator's purpose.
    desc "Generate Config file of module"

    # Creates the configuration file for the specified module.
    # This method generates the target directory and populates it with a template file.
    def create_config_file
      # Defines the target directory for the configuration file.
      config_dir = File.join("modules", module_name.underscore, "config")

      # Defines the target path for the configuration file.
      config_file = File.join(config_dir, "config.rb")

      # Creates an empty directory at the target path if it does not already exist.
      empty_directory config_dir

      # Copies the template file to the target path, replacing placeholders with actual values.
      template "config.rb.tt", config_file
    end
  end
end