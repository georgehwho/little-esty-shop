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
                .select("bulk_discounts.id, invoice_items.id, (invoice_items.unit_price * invoice_items.quantity * (bulk_discounts.percent_discount / 100.0)) as total_discount")
                .where("invoice_items.quantity >= bulk_discounts.threshold")
                .order(total_discount: :desc)
                .uniq
                .sum(&:total_discount)
  end
end
