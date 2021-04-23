class Merchant < ApplicationRecord
  default_scope {order(:name)}

  has_many :bulk_discounts, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  validates_presence_of :name

  def self.all_enabled
    where(enabled: true)
  end


  def self.all_disabled
    where(enabled: false)
  end

  def top_five_customers(merchant_id)
    customers.find_by_sql(
      "SELECT c.*, COUNT(t.id) AS count FROM customers c
        INNER JOIN invoices i ON c.id=i.customer_id
        INNER JOIN transactions t ON i.id=t.invoice_id
        INNER JOIN invoice_items it ON i.id=it.invoice_id
        INNER JOIN items ms ON ms.id=it.item_id
        INNER JOIN merchants m ON m.id=ms.merchant_id
        WHERE ms.merchant_id=#{merchant_id} AND t.result=1
        GROUP BY c.id
        ORDER BY count desc
        LIMIT 5"
                            )
  end

  def top_five_items
    invoices.joins(:transactions)
            .select("items.name as item_name, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
            .where(transactions: {result: 1})
            .group(:item_name)
            .order(revenue: :desc)
            .limit(5)
  end
end
