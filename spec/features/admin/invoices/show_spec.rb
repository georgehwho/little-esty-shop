require 'rails_helper'

describe 'admin invoice show page' do
  context 'when you land on an invoice from the admin page' do
    before {
      @invoice = create(:random_invoice)
      @inv_item_1 = create(:random_invoice_item, unit_price: 20, quantity: 5, invoice: @invoice)
      @inv_item_2 = create(:random_invoice_item, unit_price: 100, quantity: 5, invoice: @invoice)

      visit "/admin/invoices/#{@invoice.id}"
    }

    it 'shows the invoice you are on' do
      expect(page).to have_content(@invoice.id)
    end

    it 'shows a status for the invoice' do
      expect(page).to have_content(@invoice.status)
    end

    it 'shows the created on date' do
      expect(page).to have_content(@invoice.created_at.strftime("%A, %B %d, %Y"))
    end

    it 'shows total revenue' do
      expect(page).to have_content("$600.00")
    end

    it 'shows total discount' do
      expect(page).to have_content("$0.00")
    end

    it 'shows total profit' do
      expect(page).to have_content("$600.00")
    end

    it 'shows the customer it belongs to' do
      expect(page).to have_content(@invoice.customer.first_name)
      expect(page).to have_content(@invoice.customer.last_name)
    end

    it 'shows all the items on the invoice' do
      expect(page).to have_content(@inv_item_1.item.name)
      expect(page).to have_content(@inv_item_1.quantity)
      expect(page).to have_content(@inv_item_1.unit_price)
      expect(page).to have_content(@inv_item_1.status)
      expect(page).to have_content(@inv_item_2.item.name)
      expect(page).to have_content(@inv_item_2.quantity)
      expect(page).to have_content(@inv_item_2.unit_price)
      expect(page).to have_content(@inv_item_2.status)
    end
  end

  context 'when testing the update status form' do
    it 'changes to in progress' do
      invoice = create(:random_invoice, status: 1)

      visit "/admin/invoices/#{invoice.id}"

      expect(page).to have_content("cancelled")

      select 'in progress', from: "invoice_status"
      click_on "Update Invoice"

      expect(page).to have_content("in progress")
    end

    it 'changes to cancelled' do
      invoice = create(:random_invoice, status: 0)

      visit "/admin/invoices/#{invoice.id}"

      select 'cancelled', from: "invoice_status"
      click_on "Update Invoice"

      expect(page).to have_content("cancelled")
    end

    it 'changes to completed' do
      invoice = create(:random_invoice, status: 0)

      visit "/admin/invoices/#{invoice.id}"

      select 'completed', from: "invoice_status"
      click_on "Update Invoice"

      expect(page).to have_content("completed")
    end
  end
end