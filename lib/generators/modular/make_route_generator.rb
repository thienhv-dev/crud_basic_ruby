# frozen_string_literal: true

# This module defines a Rails generator for creating route files
# within a modular application structure. It automates the process of
# generating the necessary directory and template files for a module's routes.
# Usage: rails g modular:make_route ModuleName
module Modular
  class MakeRouteGenerator < Rails::Generators::Base
    # Specifies the source directory for templates used by the generator.
    source_root File.expand_path("templates", __dir__)

    # Defines an argument for the generator.
    # @param module_name [String] The name of the module for which the route files will be generated.
    argument :module_name, type: :string

    # Provides a description of the generator's purpose.
    desc "Generate Route of module"

    # Creates the route files for the specified module.
    # This method generates the target directory and populates it with template files
    # for both API and web routes.
    def create_route_files
      # Defines the target directory for the route files.
      target_path = "modules/#{module_name.underscore}/routes"

      # Creates the target directory if it doesn't exist.
      empty_directory target_path

      # Iterates over route types (API and web) and generates corresponding files
      # using the provided templates.
      %w[api web].each do |type|
        template "routes/#{type}.rb.tt", "#{target_path}/#{type}.rb"
      end
    end
  end
end