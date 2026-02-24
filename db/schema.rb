# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_02_16_234508) do
  create_table "delivery_destinations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "purchase_orders", force: :cascade do |t|
    t.string "arrival_code"
    t.datetime "created_at", null: false
    t.integer "delivery_destination_id", null: false
    t.date "desired_delivery_date"
    t.integer "message_count", default: 0
    t.date "order_date", null: false
    t.string "order_number", null: false
    t.string "status", default: "draft", null: false
    t.string "subject"
    t.integer "supplier_id", null: false
    t.integer "total_amount", default: 0
    t.datetime "updated_at", null: false
    t.index ["delivery_destination_id"], name: "index_purchase_orders_on_delivery_destination_id"
    t.index ["order_number"], name: "index_purchase_orders_on_order_number", unique: true
    t.index ["status"], name: "index_purchase_orders_on_status"
    t.index ["supplier_id"], name: "index_purchase_orders_on_supplier_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "purchase_orders", "delivery_destinations"
  add_foreign_key "purchase_orders", "suppliers"
end
