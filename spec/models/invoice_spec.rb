require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it {should belong_to :customer}
    it {should have_many :transactions}
    it {should have_many :invoice_items}
    it {should have_many :items}
  end

  describe 'class methods' do
    describe '.where_not_successful' do
      it 'returns all the invoices where the items have not been shipped' do
        invoice = create(:random_invoice)
        invoice_2 = create(:random_invoice)
        invoice_3 = create(:random_invoice)

        invoice_item_1 = create(:random_invoice_item, status: 2, invoice: invoice)
        invoice_item_2 = create(:random_invoice_item, status: 1, invoice: invoice_2)
        invoice_item_3 = create(:random_invoice_item, status: 0, invoice: invoice_3)

        expect(Invoice.where_not_successful).to eq([invoice_2, invoice_3])

        invoice_item_4 = create(:random_invoice_item, status: 0, invoice: invoice)

        expect(Invoice.where_not_successful).to eq([invoice, invoice_2, invoice_3])
      end
    end
  end
  describe 'instance methods' do
    describe '#total_revenue' do
      it 'calculates the total revenue of a invoice' do
        invoice = create(:random_invoice)
        inv_item_1 = create(:random_invoice_item, unit_price: 20, quantity: 5, invoice: invoice)
        inv_item_2 = create(:random_invoice_item, unit_price: 100, quantity: 5, invoice: invoice)

        expect(invoice.total_revenue).to eq(600)
      end
    end

    describe '#total_discount' do
      it 'calculates the total discount of a invoice' do
        merchant = create(:random_merchant)
        discount = create(:random_bulk_discount, merchant: merchant, threshold: 5, percent_discount: 10)
        discount = create(:random_bulk_discount, merchant: merchant, threshold: 4, percent_discount: 10)
        item = create(:random_item, merchant: merchant)
        invoice = create(:random_invoice)

        expect(invoice.total_discount).to eq(0)

        inv_item_1 = create(:random_invoice_item, unit_price: 20, quantity: 5, invoice: invoice, item: item)
        inv_item_2 = create(:random_invoice_item, unit_price: 100, quantity: 5, invoice: invoice, item: item)

        expect(invoice.total_discount).to eq(60)

        inv_item_3 = create(:random_invoice_item, unit_price: 100, quantity: 4, invoice: invoice, item: item)

        expect(invoice.total_discount).to eq(100)
      end

      it 'calculates the correct discount example 2' do
        merchant = create(:random_merchant)
        discount = create(:random_bulk_discount, merchant: merchant, threshold: 5, percent_discount: 10)
        discount = create(:random_bulk_discount, merchant: merchant, threshold: 4, percent_discount: 40)
        item = create(:random_item, merchant: merchant)
        invoice = create(:random_invoice)

        inv_item_1 = create(:random_invoice_item, unit_price: 20, quantity: 5, invoice: invoice, item: item)
        inv_item_2 = create(:random_invoice_item, unit_price: 100, quantity: 5, invoice: invoice, item: item)

        expect(invoice.total_discount).to eq(240)
      end
    end
  end
end
