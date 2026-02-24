class PurchaseOrder < ApplicationRecord
  belongs_to :supplier
  belongs_to :delivery_destination

  STATUSES = %w[
    draft
    pending_approval
    pending_send
    pending_delivery
    in_conversation
    delivered
    rejected
    cancelled
  ].freeze

  STATUS_LABELS = {
    "draft"             => "下書き",
    "pending_approval"  => "承認待ち",
    "pending_send"      => "送信待ち",
    "pending_delivery"  => "納品待ち",
    "in_conversation"   => "会話中",
    "delivered"         => "納品済み",
    "rejected"          => "差し戻し",
    "cancelled"         => "取り消し"
  }.freeze

  STATUS_BADGE_CLASSES = {
    "draft"             => "border border-badge-gray text-badge-gray",
    "pending_approval"  => "border border-badge-red text-badge-red",
    "pending_send"      => "border border-badge-orange text-badge-orange",
    "pending_delivery"  => "border border-badge-amber text-badge-amber",
    "in_conversation"   => "border border-badge-blue text-badge-blue",
    "delivered"         => "border border-badge-teal text-badge-teal",
    "rejected"          => "border border-badge-gray text-badge-gray",
    "cancelled"         => "border border-badge-gray text-badge-gray"
  }.freeze

  validates :order_number, presence: true, uniqueness: true
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :order_date, presence: true

  scope :by_status, ->(status) { where(status: status) if status.present? && status != "all" }
  scope :recent, -> { order(order_date: :desc, created_at: :desc) }

  def status_label
    STATUS_LABELS[status]
  end

  def status_badge_classes
    STATUS_BADGE_CLASSES[status]
  end

  def formatted_order_date
    return "" unless order_date
    wday = %w[日 月 火 水 木 金 土][order_date.wday]
    order_date.strftime("%Y/%m/%d") + "(#{wday})"
  end

  def formatted_total_amount
    ActiveSupport::NumberHelper.number_to_delimited(total_amount)
  end
end
