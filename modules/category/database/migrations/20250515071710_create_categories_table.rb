# This class defines a database migration for creating a table.
# It uses ActiveRecord's migration framework to define the structure of the table.

class CreateCategoriesTable < ActiveRecord::Migration[7.0]
  # The `change` method defines the changes to be made to the database schema.
  # In this case, it creates a new table with a name derived from the migration name.
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :description
      t.timestamps null: false
    end
  end
end