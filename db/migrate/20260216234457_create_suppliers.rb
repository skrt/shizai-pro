class CreateSuppliers < ActiveRecord::Migration[8.1]
  def change
    create_table :suppliers, id: :uuid do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
