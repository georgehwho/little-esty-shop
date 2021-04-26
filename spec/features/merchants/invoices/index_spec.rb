require 'rails_helper'

RSpec.describe "Merchant invoices Index" do
  before :each do
    @merchant = create(:random_merchant)
    @item_1 = create(:random_item, merchant_id: @merchant.id)
    @item_2 = create(:random_item, merchant_id: @merchant.id)
    @item_3 = create(:random_item, merchant_id: @merchant.id)
    @invoice_1 = create(:random_invoice)
    @invoice_2 = create(:random_invoice)
    @invoice_3 = create(:random_invoice)
    @invoice_item_1 = create(:random_invoice_item, item_id: @item_1.id, invoice_id: @invoice_3.id)
    @invoice_item_1 = create(:random_invoice_item, item_id: @item_2.id, invoice_id: @invoice_2.id)
    @invoice_item_1 = create(:random_invoice_item, item_id: @item_3.id, invoice_id: @invoice_1.id)

  end
  describe "When I visit my merchant invoices index" do
    it "I see all of the invoices that include at least one of my merchants items" do
      visit merchant_invoices_path(@merchant)

      expect(page).to have_content(@invoice_1.id)
      expect(page).to have_content(@invoice_3.id)
      expect(page).to have_content(@invoice_2.id)
    end
  end
end
