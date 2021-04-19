require 'rails_helper'

RSpec.describe "As a Merchant" do
  before {
    @merchant = create(:random_merchant)
  }

  context "When I visit my merchant dashboard" do
    it "I see the name of my merchant" do
      visit merchant_dashboard_index_path(@merchant)

      expect(page).to have_content(@merchant.name)
    end

    it "I see a link to my merchant items and invoices index" do
      visit merchant_dashboard_index_path(@merchant)

      expect(page).to have_link('My Items')
      expect(page).to have_link('My Invoices')
    end

    it "I see a list of items ordered but not shipped yet with invoice id link" do
      item_1 = create(:random_item, merchant_id: @merchant.id)
      item_2 = create(:random_item, merchant_id: @merchant.id)
      item_3 = create(:random_item, merchant_id: @merchant.id)
      item_4 = create(:random_item, merchant_id: @merchant.id)
      item_5 = create(:random_item, merchant_id: @merchant.id)
      item_6 = create(:random_item, merchant_id: @merchant.id)
      invoice_item_1 = create(:random_invoice_item, item: item_1, status: 0)
      invoice_item_2 = create(:random_invoice_item, item: item_2, status: 1)
      invoice_item_3 = create(:random_invoice_item, item: item_3, status: 0)
      invoice_item_4 = create(:random_invoice_item, item: item_4, status: 1)
      invoice_item_5 = create(:random_invoice_item, item: item_5, status: 0)
      invoice_item_6 = create(:random_invoice_item, item: item_6, status: 2)
      item_7 = create(:random_item)

      visit merchant_dashboard_index_path(@merchant)

      within ".merchant-items" do
        expect(page).to have_content(item_1.name)
        expect(page).to have_content(item_2.name)
        expect(page).to have_content(item_3.name)
        expect(page).to have_content(item_4.name)
        expect(page).to have_content(item_5.name)
        expect(page).to_not have_content(item_6.name)
        expect(page).to_not have_content(item_7.name)
        expect(page).to have_link(invoice_item_1.invoice_id)
      end
    end

    it "I see the date the invoice was created, oldest to newest" do
      item_1 = create(:random_item, merchant_id: @merchant.id)
      item_2 = create(:random_item, merchant_id: @merchant.id)
      item_3 = create(:random_item, merchant_id: @merchant.id)
      item_4 = create(:random_item, merchant_id: @merchant.id)
      item_5 = create(:random_item, merchant_id: @merchant.id)
      item_6 = create(:random_item, merchant_id: @merchant.id)
      invoice_item_1 = create(:random_invoice_item, item: item_1, status: 0)
      invoice_item_2 = create(:random_invoice_item, item: item_2, status: 1)
      invoice_item_3 = create(:random_invoice_item, item: item_3, status: 0)
      invoice_item_4 = create(:random_invoice_item, item: item_4, status: 1)
      invoice_item_5 = create(:random_invoice_item, item: item_5, status: 0)
      invoice_item_6 = create(:random_invoice_item, item: item_6, status: 2)
      item_7 = create(:random_item)

      visit merchant_dashboard_index_path(@merchant)

      within ".merchant-items" do
        expect(page).to have_content(invoice_item_1.invoice.created_at.strftime("%A, %B %d, %Y"))
      end
    end

    it "I see the names of the top 5 customers" do
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

      visit merchant_dashboard_index_path(merchant)

      within ".favorite-customers" do
        expect(page).to have_content(customer_1.name)
        expect(page).to have_content(customer_2.name)
        expect(page).to have_content(customer_3.name)
        expect(page).to have_content(customer_4.name)
        expect(page).to have_content(customer_5.name)
      end
    end
  end
end
