require 'rails_helper'

RSpec.describe "Merchant Invoice Show Page" do
  before :each do
    @merchant = create(:random_merchant)
    @item_1 = create(:random_item, merchant: @merchant)
    @invoice_1 = create(:random_invoice)
    @invoice_item_1 = create(:random_invoice_item, quantity: 75, unit_price: 17600, status: 'pending', item: @item_1, invoice: @invoice_1)

    visit merchant_invoice_path(@merchant, @invoice_1)
  end

  describe "As a visitor (/merchants/merchant_id/invoices/invoice_id)" do

    it "I see information related to that invoice index" do

      expect(page).to have_content(@invoice_1.id)
      expect(page).to have_content(@invoice_1.status)
      expect(page).to have_content(@invoice_1.created_at.strftime("%A, %B %d, %Y"))

      within ".customer" do
        expect(page).to have_content(@invoice_1.customer.name)
      end
    end

    it "I see information of the items on the invoice" do

      within ".show-items" do
        expect(page).to have_content(@item_1.name)
        expect(page).to have_content(75)
        expect(page).to have_content('$17,600.00')
        expect(page).to have_content('pending')
      end
    end

    it "I see total revenue that will be generated from items on invoice" do

      within ".total-revenue" do
        expect(page).to have_content('$1,320,000.00')
      end
    end

    it "I see a dropdown to update the invoice status" do
      expect(page).to have_button('Update Invoice')

      select "completed", from: 'Status'
      click_on 'Update Invoice'

      expect(current_path).to eq(merchant_invoice_path(@merchant, @invoice_1))
      expect(field: 'Status').to eq("completed")
    end
  end
end
