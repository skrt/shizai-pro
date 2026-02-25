class CreatePurchaseOrderItems < ActiveRecord::Migration[8.1]
  def change
    create_table :purchase_order_items do |t|
      t.references :purchase_order, null: false, foreign_key: true
      t.string :item_name
      t.string :item_code
      t.date :desired_delivery_date
      t.integer :quantity
      t.integer :unit_price
      t.integer :amount

      t.timestamps
    end
  end
end
