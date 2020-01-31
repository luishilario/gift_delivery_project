class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :name
      t.text :address
      t.numeric :phone
      t.references :school, null: false, foreign_key: true

      t.timestamps
    end
  end
end
