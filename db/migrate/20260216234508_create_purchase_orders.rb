class CreatePurchaseOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :purchase_orders do |t|
      t.string :order_number, null: false
      t.string :arrival_code
      t.string :subject
      t.string :status, null: false, default: "draft"
      t.date :order_date, null: false
      t.date :desired_delivery_date
      t.references :supplier, null: false, foreign_key: true
      t.references :delivery_destination, null: false, foreign_key: true
      t.integer :total_amount, default: 0
      t.integer :message_count, default: 0

      t.timestamps
    end

    add_index :purchase_orders, :order_number, unique: true
    add_index :purchase_orders, :status
  end
end
