# frozen_string_literal: true

# This module defines a Rails generator for creating a migration file
# within a modular application structure. It automates the process of
# generating the necessary directory and template file for a module's migration.
# Usage: rails g modular:make_migration MigrationName ModuleName
module Modular
  class MakeMigrationGenerator < Rails::Generators::Base
    # Includes Rails::Generators::Migration to provide migration-related utilities.
    include Rails::Generators::Migration

    # Specifies the source directory for templates used by the generator.
    source_root File.expand_path("templates", __dir__)

    # Defines an argument for the generator.
    # @param migration_name [String] The name of the migration to be generated.
    # @param module_name [String] The name of the module for which the migration will be generated.
    argument :migration_name, type: :string
    argument :module_name, type: :string

    # Provides a description of the generator's purpose.
    desc "Generate migration file inside module"

    # Creates the migration file for the specified module and migration name.
    # This method generates the target directory and populates it with a template file.
    def create_migration_file
      # Defines the target path for the migration file.
      target_path = "modules/#{module_name.underscore}/database/migrations"

      # Creates the target directory if it does not exist.
      empty_directory target_path

      timestamp = Time.now.strftime('%Y%m%d%H%M%S')
      # Constructs the migration file name by combining the timestamp and the underscored migration name.
      migration_file_name = "#{timestamp}_#{migration_name.underscore}.rb"

      template "migration.rb.tt", File.join(target_path, migration_file_name)
    end
  end
end
