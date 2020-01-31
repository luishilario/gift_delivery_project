class CreateJoinTableGiftOrder < ActiveRecord::Migration[6.0]
  def change
    create_join_table :gifts, :orders do |t|
      t.index [:gift_id, :order_id]
      t.index [:order_id, :gift_id]
    end
  end
end
