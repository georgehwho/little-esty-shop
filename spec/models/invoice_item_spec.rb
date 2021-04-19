require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "relationships" do
    it {should belong_to :invoice}
    it {should belong_to :item}
  end

  describe "validations" do
    it {should validate_presence_of :quantity}
    it {should validate_presence_of :unit_price}
  end

  describe "class methods" do

    describe ".items_ready_to_ship" do
      it "returns invoice_ids of items not shipped" do
        merchant = create(:random_merchant, id: 22)
        item_1 = create(:random_item, id: 1, merchant_id: 22)
        item_2 = create(:random_item, id: 2, merchant_id: 22)
        item_3 = create(:random_item, id: 3, merchant_id: 22)
        invoice_item_1 = create(:random_invoice_item, item: item_1, status: 0)
        invoice_item_2 = create(:random_invoice_item, item: item_2, status: 1)
        invoice_item_3 = create(:random_invoice_item, item: item_3, status: 2)
        expect(InvoiceItem.items_ready_to_ship(merchant).count).to eq(2)
      end
    end

    describe ".by_merchant(merchant)" do
      it "returns the invoices by merchant" do
        merchant = create(:random_merchant, id: 22)
        item_1 = create(:random_item, id: 1, merchant_id: 22)
        item_2 = create(:random_item, id: 2, merchant_id: 22)
        item_3 = create(:random_item, id: 3, merchant_id: 22)
        item_4 = create(:random_item)
        invoice_1 = create(:random_invoice)
        invoice_2 = create(:random_invoice)
        invoice_3 = create(:random_invoice)
        invoice_item_1 = create(:random_invoice_item, item: item_1, invoice: invoice_1, status: 0)
        invoice_item_2 = create(:random_invoice_item, item: item_2, invoice: invoice_1, status: 1)
        invoice_item_3 = create(:random_invoice_item, item: item_3, invoice: invoice_2, status: 2)
        invoice_item_4 = create(:random_invoice_item)
        expect(InvoiceItem.by_merchant(merchant)).to eq([invoice_1, invoice_2])
      end

      it '.highest_revenue_merchant_ids' do
        item_1 = create(:random_item)
        item_2 = create(:random_item)
        item_3 = create(:random_item)
        item_4 = create(:random_item)
        item_5 = create(:random_item)
        item_6 = create(:random_item)
        item_7 = create(:random_item)

        invoice_1 = create(:random_invoice)
        invoice_2 = create(:random_invoice)
        invoice_3 = create(:random_invoice)
        invoice_4 = create(:random_invoice)
        invoice_5 = create(:random_invoice)
        invoice_6 = create(:random_invoice)
        invoice_7 = create(:random_invoice)

        invoice_item_1 = create(:random_invoice_item, invoice: invoice_1, item: item_1, unit_price: 1, quantity: 1)
        invoice_item_2 = create(:random_invoice_item, invoice: invoice_2, item: item_2, unit_price: 2, quantity: 1)
        invoice_item_3 = create(:random_invoice_item, invoice: invoice_3, item: item_3, unit_price: 3, quantity: 1)
        invoice_item_4 = create(:random_invoice_item, invoice: invoice_4, item: item_4, unit_price: 4, quantity: 1)
        invoice_item_5 = create(:random_invoice_item, invoice: invoice_5, item: item_5, unit_price: 5, quantity: 1)
        invoice_item_6 = create(:random_invoice_item, invoice: invoice_6, item: item_6, unit_price: 6, quantity: 1)
        invoice_item_7 = create(:random_invoice_item, invoice: invoice_7, item: item_7, unit_price: 0, quantity: 1)

        transaction_1 = create(:random_transaction, result: 1, invoice: invoice_1)
        transaction_2 = create(:random_transaction, result: 1, invoice: invoice_2)
        transaction_3 = create(:random_transaction, result: 1, invoice: invoice_3)
        transaction_4 = create(:random_transaction, result: 1, invoice: invoice_4)
        transaction_5 = create(:random_transaction, result: 1, invoice: invoice_5)
        transaction_6 = create(:random_transaction, result: 0, invoice: invoice_6)
        transaction_7 = create(:random_transaction, result: 1, invoice: invoice_7)

        expect(InvoiceItem.highest_revenue_merchant_ids.first.revenue).to eq(5)
        expect(InvoiceItem.highest_revenue_merchant_ids.last.revenue).to eq(1)
      end

      it '.best_date_by_merchant_id' do
        merchant_1 = create(:random_merchant)
        item_1 = create(:random_item, merchant: merchant_1)
        invoice_1 = create(:random_invoice)
        invoice_2 = create(:random_invoice)
        invoice_item_1 = create(:random_invoice_item, invoice: invoice_1, item: item_1, unit_price: 1, quantity: 1, created_at: 20)
        invoice_item_2 = create(:random_invoice_item, invoice: invoice_2, item: item_1, unit_price: 2, quantity: 1,created_at: 100)
        transaction_1 = create(:random_transaction, result: 1, invoice: invoice_1)
        transaction_2 = create(:random_transaction, result: 1, invoice: invoice_2)

        expect(InvoiceItem.best_date_by_merchant_id(merchant_1.id)).to eq(invoice_item_2.created_at)
      end

      it '.invoice_items_details by invoice' do
        merchant = create(:random_merchant)
        item_1 = create(:random_item, merchant: merchant)
        invoice_1 = create(:random_invoice)
        invoice_item_1 = create(:random_invoice_item, status: 'pending', unit_price: 17600, quantity: 75, item: item_1, invoice: invoice_1)
      
        expect(InvoiceItem.invoice_items_details(invoice_1).first.status).to eq('pending')
      end
    end
  end
end
