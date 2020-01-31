class CreateJoinTableOrderRecipient < ActiveRecord::Migration[6.0]
  def change
    create_join_table :orders, :recipients do |t|
      t.index [:order_id, :recipient_id]
      t.index [:recipient_id, :order_id]
    end
  end
end
