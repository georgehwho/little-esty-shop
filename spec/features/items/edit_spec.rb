require 'rails_helper'

RSpec.describe "Merchant Items Show Page" do
  before :each do
    @merchant = create(:random_merchant, id: 22)
    @item_1 = create(:random_item, id: 1, merchant_id: 22)

    visit merchant_item_path(@merchant.id)
  end

  context "I click the link to update item information" do
    before :each do
      click_link("Update Item")
    end

    it "I am taken to a form to a page to edit this item, with the existing item's attributes filled in" do
      expect(current_path).to eq(merchant_item_edit_path(@item_1))

      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@item_1.description)
      expect(page).to have_content(@item_1.unit_price)
    end

    it "I fill in new attributes and click 'submit' and the item is updated" do
      fill_in 'Name', with: 'New Name'
      fill_in 'Description', with: 'Dildo'
      fill_in 'Price', with: 69420

      click_on 'Submit'

      expect(current_path).to eq(merchant_item_path(@item_1))
      expect(page).to have_content('Item successfully updated!')
      expect(page).to have_content('New Name')
      expect(page).to have_content('Dildo')
      expect(page).to have_content(69420)
    end
  end
end
