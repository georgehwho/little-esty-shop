require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it {should have_many :items}
    it { should have_many :bulk_discounts }
  end

  describe "validations" do
    it {should validate_presence_of :name}
  end

  describe "Instance Methods" do

    describe "#top_five_customers" do
      it "returns a the first five customers with most successful transactions" do
        merchant = create(:random_merchant, id: 22)
        item_1 = create(:random_item, id: 1, merchant_id: 22)
        item_2 = create(:random_item, id: 2, merchant_id: 22)
        item_3 = create(:random_item, id: 3, merchant_id: 22)
        item_4 = create(:random_item, id: 4, merchant_id: 22)
        item_5 = create(:random_item, id: 5, merchant_id: 22)
        item_6 = create(:random_item, id: 6, merchant_id: 22)

        customer_1 = create(:random_customer)
        customer_2 = create(:random_customer)
        customer_3 = create(:random_customer)
        customer_4 = create(:random_customer)
        customer_5 = create(:random_customer)
        customer_6 = create(:random_customer)

        invoice_1 = create(:random_invoice, customer: customer_1)
        invoice_2 = create(:random_invoice, customer: customer_2)
        invoice_3 = create(:random_invoice, customer: customer_3)
        invoice_4 = create(:random_invoice, customer: customer_4)
        invoice_5 = create(:random_invoice, customer: customer_5)
        invoice_6 = create(:random_invoice, customer: customer_6)

        invoice_item_1 = create(:random_invoice_item, invoice: invoice_1, item: item_1, status: 0)
        invoice_item_2 = create(:random_invoice_item, invoice: invoice_2, item: item_2, status: 1)
        invoice_item_3 = create(:random_invoice_item, invoice: invoice_3, item: item_3, status: 2)
        invoice_item_4 = create(:random_invoice_item, invoice: invoice_4, item: item_4, status: 2)
        invoice_item_5 = create(:random_invoice_item, invoice: invoice_5, item: item_5, status: 2)
        invoice_item_6 = create(:random_invoice_item, invoice: invoice_6, item: item_6, status: 2)

        transaction_1 = create(:random_transaction, result: 1, invoice: invoice_1)
        transaction_2 = create(:random_transaction, result: 1, invoice: invoice_2)
        transaction_3 = create(:random_transaction, result: 1, invoice: invoice_3)
        transaction_4 = create(:random_transaction, result: 1, invoice: invoice_4)
        transaction_5 = create(:random_transaction, result: 1, invoice: invoice_5)
        transaction_6 = create(:random_transaction, result: 0, invoice: invoice_6)

        expect(merchant.top_five_customers(merchant.id)).to eq([
          customer_1, customer_2, customer_3, customer_4, customer_5
          ])
        end
      end
    end

    describe "#top_five_items" do
      it "returns the top 5 items with the most total revenue" do
        merchant = create(:random_merchant, id: 22)
        item_1 = create(:random_item, id: 1, merchant_id: 22)
        item_2 = create(:random_item, id: 2, merchant_id: 22)
        item_3 = create(:random_item, id: 3, merchant_id: 22)
        item_4 = create(:random_item, id: 4, merchant_id: 22)
        item_5 = create(:random_item, id: 5, merchant_id: 22)
        item_6 = create(:random_item, id: 6, merchant_id: 22)

        customer_1 = create(:random_customer)
        customer_2 = create(:random_customer)
        customer_3 = create(:random_customer)
        customer_4 = create(:random_customer)
        customer_5 = create(:random_customer)
        customer_6 = create(:random_customer)

        invoice_1 = create(:random_invoice, customer: customer_1)
        invoice_2 = create(:random_invoice, customer: customer_2)
        invoice_3 = create(:random_invoice, customer: customer_3)
        invoice_4 = create(:random_invoice, customer: customer_4)
        invoice_5 = create(:random_invoice, customer: customer_5)
        invoice_6 = create(:random_invoice, customer: customer_6)

        invoice_item_1 = create(:random_invoice_item, unit_price: 100, quantity: 10, invoice: invoice_1, item: item_1, status: 0)
        invoice_item_2 = create(:random_invoice_item, unit_price: 90, quantity: 9, invoice: invoice_2, item: item_2, status: 1)
        invoice_item_3 = create(:random_invoice_item, unit_price: 80, quantity: 8, invoice: invoice_3, item: item_3, status: 2)
        invoice_item_4 = create(:random_invoice_item, unit_price: 10, quantity: 1, invoice: invoice_4, item: item_4, status: 2)
        invoice_item_5 = create(:random_invoice_item, unit_price: 70, quantity: 7, invoice: invoice_5, item: item_5, status: 2)
        invoice_item_6 = create(:random_invoice_item, unit_price: 60, quantity: 6, invoice: invoice_6, item: item_6, status: 2)

        transaction_1 = create(:random_transaction, result: 1, invoice: invoice_1)
        transaction_2 = create(:random_transaction, result: 1, invoice: invoice_2)
        transaction_3 = create(:random_transaction, result: 1, invoice: invoice_3)
        transaction_4 = create(:random_transaction, result: 1, invoice: invoice_4)
        transaction_5 = create(:random_transaction, result: 1, invoice: invoice_5)
        transaction_6 = create(:random_transaction, result: 1, invoice: invoice_6)

        actual = merchant.top_five_items
        expected = actual.map(&:item_name)
        expect([item_1.name, item_2.name, item_3.name, item_5.name, item_6.name]).to eq(expected)
      end
    end

  describe 'class methods' do
    context 'enabled and disabled' do
      before do
        @merchant_1 = create(:random_merchant, enabled: true)
        @merchant_2 = create(:random_merchant, enabled: false)
      end

      it '.all_enabled' do
        expect(Merchant.all_enabled).to eq([@merchant_1])
      end

      it '.all_disabled' do
        expect(Merchant.all_disabled).to eq([@merchant_2])
      end
    end
  end
end
