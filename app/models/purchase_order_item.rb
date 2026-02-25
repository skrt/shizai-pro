class PurchaseOrderItem < ApplicationRecord
  belongs_to :purchase_order

  def formatted_desired_delivery_date
    return "" unless desired_delivery_date
    wday = %w[日 月 火 水 木 金 土][desired_delivery_date.wday]
    desired_delivery_date.strftime("%Y/%m/%d") + "(#{wday})"
  end

  def formatted_quantity
    ActiveSupport::NumberHelper.number_to_delimited(quantity)
  end

  def formatted_unit_price
    ActiveSupport::NumberHelper.number_to_delimited(unit_price)
  end

  def formatted_amount
    ActiveSupport::NumberHelper.number_to_delimited(amount)
  end
end
