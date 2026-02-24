class PurchaseOrdersController < ApplicationController
  def index
    @status_filter = params[:status] || "all"
    @purchase_orders = PurchaseOrder.includes(:supplier, :delivery_destination).recent
    @purchase_orders = @purchase_orders.by_status(@status_filter) unless @status_filter == "all"

    @status_counts = PurchaseOrder.group(:status).count

    @page = (params[:page] || 1).to_i
    @per_page = 20
    @total_count = @purchase_orders.count
    @total_pages = [(@total_count.to_f / @per_page).ceil, 1].max
    @page = @page.clamp(1, @total_pages)
    @purchase_orders = @purchase_orders.offset((@page - 1) * @per_page).limit(@per_page)

    @suppliers = Supplier.order(:name)
    @delivery_destinations = DeliveryDestination.order(:name)
  end
end
