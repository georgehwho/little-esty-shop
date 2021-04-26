require 'rails_helper'

RSpec.describe "Merchant Item Update" do
  before :each do
    @merchant = create(:random_merchant, id: 22)
    @item_1 = create(:random_item, id: 1, merchant_id: 22)
    @item_2 = create(:random_item, id: 2, merchant_id: 22)

  end
  describe "I see a link to Update the information" do
    it "When I click the link I am taken to the update page for the item" do
      visit merchant_item_path(@merchant, @item_1)

      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@item_1.description)
      expect(page).to have_content(@item_1.unit_price)
      expect(page).to have_link("Update Item")
      click_on "Update Item"
      expect(current_path).to eq(edit_merchant_item_path(@merchant, @item_1))
    end

    it "I see a form filled in with existing item info" do
      visit edit_merchant_item_path(@merchant, @item_1)
      expect(find_field('Name').value).to have_content(@item_1.name)
      expect(find_field('Description').value).to have_content(@item_1.description)
      expect(find_field('Unit price').value).to have_content(@item_1.unit_price)
      expect(page).to have_button('Update Item')

    end

    it "When I update information and click submit, I am redirected back to the show page" do
      visit edit_merchant_item_path(@merchant, @item_1)

      fill_in "Name", with: "name"
      fill_in "Description", with: "description"
      fill_in "Unit price", with: 1
      click_on "Update Item"
      expect(current_path).to eq(merchant_item_path(@merchant, @item_1))
      expect(page).to have_content("Item successfully updated!")
    end

    it "When I update information and click submit, I am redirected back to the show page" do
      visit edit_merchant_item_path(@merchant, @item_1)

      fill_in "Name", with: ""
      fill_in "Description", with: ""
      fill_in "Unit price", with: ''
      click_on "Update Item"
      expect(current_path).to eq(edit_merchant_item_path(@merchant, @item_1))
      expect(page).to have_content("Error: Name can't be blank, Description can't be blank, Unit price can't be blank, Unit price is not a number")
    end


  end
end
