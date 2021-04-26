require 'rails_helper'

RSpec.describe "Merchant Items Show Page" do
  describe "I see all of the items attributes" do
    it "Has name, description, current selling price" do
      merchant = create(:random_merchant, id: 22)
      item_1 = create(:random_item, id: 1, merchant_id: 22)
      item_2 = create(:random_item, id: 2, merchant_id: 22)

      visit merchant_item_path(merchant, item_1)

      expect(page).to have_content(item_1.name)
      expect(page).to have_content(item_1.description)
      expect(page).to have_content(item_1.unit_price)
    end
  end
end
