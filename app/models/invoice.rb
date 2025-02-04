class Invoice < ApplicationRecord
  belongs_to :customer

  has_many :transactions, dependent: :destroy

  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items

  enum status: [:"in progress", :cancelled, :completed]

  def self.where_not_successful
    self.joins(:invoice_items)
        .where.not("invoice_items.status=2")
        .order(:created_at)
        .distinct
  end

  def total_revenue
    invoice_items.sum("invoice_items.unit_price * invoice_items.quantity")
  end

  def total_discount
    invoice_items.joins(:bulk_discounts)
                  .select("invoice_items.id, max(invoice_items.unit_price * invoice_items.quantity * (bulk_discounts.percent_discount / 100.0)) as total_discount")
                  .where("invoice_items.quantity >= bulk_discounts.threshold")
                  .group("invoice_items.id")
                  .order(total_discount: :desc)
                  .sum(&:total_discount)
  end

  def total_discount_items
    invoice_items.joins(:bulk_discounts)
                  .select("invoice_items.*, bulk_discounts.id as bd_id, max(invoice_items.unit_price * invoice_items.quantity * (bulk_discounts.percent_discount / 100.0)) as total_discount")
                  .where("invoice_items.quantity >= bulk_discounts.threshold")
                  .group("invoice_items.id, bd_id")
                  .order(total_discount: :desc)
  end
end
