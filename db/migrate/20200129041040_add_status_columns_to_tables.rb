class AddStatusColumnsToTables < ActiveRecord::Migration[6.0]
  def change
    add_column :schools, :status, :integer, :default => 1
    add_column :recipients, :status, :boolean, :default => 1
  end
end
