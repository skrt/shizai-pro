class CreateDeliveryDestinations < ActiveRecord::Migration[8.1]
  def change
    create_table :delivery_destinations, id: :uuid do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
