class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  enum status: [:packaged, :pending, :shipped]

  validates_presence_of :quantity, :unit_price

  def self.lines_not_shipped
    where('status != ?', 2)
  end


  def self.items_ready_to_ship(merchant)
    find_by_sql(
      "SELECT item.merchant_id AS merchant_id, item.name AS item_name,
      item.id AS item_id, ii.status, inv.id AS invoice_id, inv.created_at AS created_at
        FROM invoice_items ii
          INNER JOIN items item
          ON ii.item_id=item.id
          INNER JOIN invoices inv
          ON ii.invoice_id=inv.id
          WHERE item.merchant_id=#{merchant.id}
          AND ii.status != 2
          ORDER BY created_at"
    )
  end

  def self.by_merchant(merchant)
    merchant.invoices.uniq
  end

  # this currently returns all merchant_id's by highest revenue
  def self.highest_revenue_merchant_ids
    joins(:item, invoice: :transactions)
    .select("items.merchant_id, sum(invoice_items.unit_price * invoice_items.quantity) as revenue")
    .where("transactions.result = 1")
    .group("items.merchant_id")
    .order(revenue: :desc)
    .limit(5)
  end

  def self.best_date_by_merchant_id(merchant_id)
    joins(:item, invoice: :transactions)
    .select("invoice_items.created_at, sum(invoice_items.unit_price * invoice_items.quantity) as revenue")
    .where("transactions.result = 1 AND items.merchant_id = ?", merchant_id)
    .group("invoice_items.created_at")
    .order(revenue: :desc)
    .limit(1)
    .first
    .created_at
  end

  def self.invoice_items_details(invoice)
    find_by_sql("SELECT inv.id, i.name AS name,
                ii.quantity AS quantity_ordered,
                ii.unit_price AS price_sold,
                ii.status AS status
                FROM invoice_items ii
                INNER JOIN items i
                ON i.id=ii.item_id
                INNER JOIN merchants m
                ON m.id=i.merchant_id
                INNER JOIN invoices inv
                ON inv.id=ii.invoice_id
                WHERE inv.id=#{invoice.id}"
              )
  end
end
