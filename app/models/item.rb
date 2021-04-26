class Item < ApplicationRecord
  belongs_to :merchant

  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :bulk_discounts, through: :merchant

  validates_presence_of :name, :description
  validates :unit_price, presence: true, numericality: true

  def self.not_shipped
      self.joins(:invoice_items)
          .where('status != ?', 2)
  end

  def self.items_enabled
    where(enabled: true)
  end

  def self.items_disabled
    where(enabled: false)
  end

  def top_sales_day
    invoices.select("invoices.*, (invoice_items.quantity * invoice_items.unit_price) as revenue")
            .order("revenue desc")
            .limit(1)
            .first
            .created_at
            .strftime('%m/%d/%y')
  end

end
