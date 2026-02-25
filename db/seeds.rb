# Suppliers
shizai = Supplier.find_or_create_by!(name: "株式会社shizai")
niiyama = Supplier.find_or_create_by!(name: "にいやま株式会社")
supplier_co = Supplier.find_or_create_by!(name: "株式会社サプライヤー")
test_supplier = Supplier.find_or_create_by!(name: "仕入先テスト")

# Delivery Destinations
warehouse_a = DeliveryDestination.find_or_create_by!(name: "倉庫A")
warehouse_dev = DeliveryDestination.find_or_create_by!(name: "dev")
warehouse_main = DeliveryDestination.find_or_create_by!(name: "倉庫")

# Purchase Orders matching Figma screenshot
orders = [
  { order_number: "20260216-003", arrival_code: nil,             subject: nil,        status: "draft",            order_date: "2026-02-16", supplier: shizai,        delivery_destination: warehouse_a,    total_amount: 0,         message_count: 0 },
  { order_number: "20260216-002", arrival_code: nil,             subject: "test",     status: "pending_approval", order_date: "2026-02-16", supplier: niiyama,       delivery_destination: warehouse_a,    total_amount: 66_000,    message_count: 0 },
  { order_number: "20260216-001", arrival_code: "2960021235066", subject: "test",     status: "pending_delivery", order_date: "2026-02-16", supplier: niiyama,       delivery_destination: warehouse_a,    total_amount: 66_000,    message_count: 1 },
  { order_number: "20260113-001", arrival_code: "2960020629873", subject: "テスト",   status: "delivered",        order_date: "2026-01-13", supplier: shizai,        delivery_destination: warehouse_a,    total_amount: 132_000,   message_count: 0 },
  { order_number: "20260107-005", arrival_code: nil,             subject: "あああ",   status: "pending_approval", order_date: "2026-01-07", supplier: supplier_co,   delivery_destination: warehouse_dev,  total_amount: 132_000,   message_count: 0 },
  { order_number: "20260107-003", arrival_code: "2960020529319", subject: nil,        status: "pending_delivery", order_date: "2026-01-07", supplier: test_supplier, delivery_destination: warehouse_a,    total_amount: 297_000,   message_count: 0 },
  { order_number: "20260107-002", arrival_code: "2960020529128", subject: nil,        status: "pending_delivery", order_date: "2026-01-07", supplier: test_supplier, delivery_destination: warehouse_a,    total_amount: 352_000,   message_count: 0 },
  { order_number: "20220401_003", arrival_code: "1234567890123", subject: "Cell Data", status: "delivered",       order_date: "2022-12-27", supplier: shizai,        delivery_destination: warehouse_main, total_amount: 99_999_999, message_count: 0 },
  { order_number: "20220401_004", arrival_code: "1234567890123", subject: "Cell Data", status: "delivered",       order_date: "2022-12-27", supplier: shizai,        delivery_destination: warehouse_main, total_amount: 99_999_999, message_count: 0 },
  { order_number: "20220401_005", arrival_code: "1234567890123", subject: "Cell Data", status: "delivered",       order_date: "2022-12-27", supplier: shizai,        delivery_destination: warehouse_main, total_amount: 99_999_999, message_count: 0 },
  { order_number: "20220401_006", arrival_code: "1234567890123", subject: "Cell Data", status: "pending_approval", order_date: "2022-12-27", supplier: shizai,       delivery_destination: warehouse_main, total_amount: 99_999_999, message_count: 0 },
  { order_number: "20220401_007", arrival_code: "1234567890123", subject: "Cell Data", status: "draft",           order_date: "2022-12-27", supplier: shizai,        delivery_destination: warehouse_main, total_amount: 99_999_999, message_count: 0 },
]

# Additional data to fill pagination
suppliers_all = [shizai, niiyama, supplier_co, test_supplier]
dests_all = [warehouse_a, warehouse_dev, warehouse_main]
statuses = PurchaseOrder::STATUSES

40.times do |i|
  date = Date.new(2025, 6, 1) + i.days
  orders << {
    order_number: date.strftime("%Y%m%d") + "-#{format('%03d', (i % 3) + 1)}",
    arrival_code: i.even? ? "296002#{rand(1_000_000..9_999_999)}" : nil,
    subject: ["テスト発注", "サンプル", "定期発注", nil].sample,
    status: statuses.sample,
    order_date: date,
    supplier: suppliers_all.sample,
    delivery_destination: dests_all.sample,
    total_amount: [0, 33_000, 66_000, 99_000, 132_000, 297_000].sample,
    message_count: [0, 0, 0, 1, 2].sample
  }
end

orders.each do |attrs|
  PurchaseOrder.find_or_create_by!(order_number: attrs[:order_number]) do |po|
    po.assign_attributes(attrs)
  end
end

# Purchase Order Items (line items for expand row)
item_names = [
  "パウチ 100mm×150mm",
  "配送箱 A4サイズ",
  "ラベルシール 丸型",
  "緩衝材 エアキャップ",
  "OPP袋 A5サイズ",
  "段ボール B5",
  "テープ 透明 48mm",
  "封筒 角2"
]

PurchaseOrder.find_each do |po|
  next if po.items.any?

  item_count = rand(1..4)
  item_count.times do |i|
    name = item_names.sample
    code = "ITM-#{rand(10_000..99_999)}"
    qty = [100, 200, 270, 500, 1_000].sample
    price = [50, 100, 150, 200, 330, 500].sample
    po.items.create!(
      item_name: name,
      item_code: code,
      desired_delivery_date: po.order_date + rand(7..30).days,
      quantity: qty,
      unit_price: price,
      amount: qty * price
    )
  end
end

puts "Seeded: #{Supplier.count} suppliers, #{DeliveryDestination.count} destinations, #{PurchaseOrder.count} purchase orders, #{PurchaseOrderItem.count} items"
