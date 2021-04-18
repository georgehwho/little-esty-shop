require 'rails_helper'

RSpec.describe "Merchant Items Show Page" do
  before :each do
    @merchant = create(:random_merchant, id: 22)
    @item_1 = create(:random_item, id: 1, merchant_id: 22)

    visit merchant_item_path(@merchant.id)
  end


  context "I visit the item's show page" do
    it "I see the item's attributes" do
      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@item_1.description)
      expect(page).to have_content(@item_1.unit_price)
    end

    it "I see a link to update item information" do
      expect(page).to have_link(@item_1.update)
    end
  end
end
