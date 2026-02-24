class CreateDeliveryDestinations < ActiveRecord::Migration[8.1]
  def change
    create_table :delivery_destinations do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
