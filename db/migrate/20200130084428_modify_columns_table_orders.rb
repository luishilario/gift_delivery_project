class ModifyColumnsTableOrders < ActiveRecord::Migration[6.0]
  def change
    remove_column :orders, :name
    remove_column :orders, :address
    remove_column :orders, :phone
    add_column :orders, :status, :integer
    add_column :orders, :notification, :integer
  end
end
