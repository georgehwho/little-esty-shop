require 'rails_helper'

RSpec.describe "Merchant New Item" do
  before :each do
    @merchant = create(:random_merchant, id: 22)
  end

  describe "When I visit my items index page" do
    it "I see a link to create a new item" do
      visit merchant_items_path(@merchant)

      expect(page).to have_link("New item")
    end

    context "And then I click on the link" do
      it "I am taken to a form that allows me to add new item information" do
        visit new_merchant_item_path(@merchant)

        fill_in "Name", with: "new name"
        fill_in "Description", with: "description"
        fill_in "Unit price", with: 3

        click_on "Create Item"


        expect(current_path).to eq(merchant_items_path(@merchant))
        within "#disabled-items" do
          expect(page).to have_content("new name")
        end
      end

      it "I am taken to a form that allows me to add new item information" do
        visit new_merchant_item_path(@merchant)

        fill_in "Name", with: ""
        fill_in "Description", with: ""
        fill_in "Unit price", with: ''

        click_on "Create Item"


        expect(current_path).to eq(new_merchant_item_path(@merchant))

        expect(page).to have_content("Error: Name can't be blank, Description can't be blank, Unit price can't be blank, Unit price is not a number")


      end

    end
  end
end
