require 'rails_helper'

describe 'bulk discount index page' do
  before {
    @merchant = create(:random_merchant)
    @bd_1 = create(:random_bulk_discount, merchant: @merchant)
    @bd_2 = create(:random_bulk_discount, merchant: @merchant)

    visit merchant_dashboard_index_path(@merchant)
    click_on("My Discounts")
  }

  context 'you land on the index page' do
    it 'shows you all of the bulk discounts including their percetage discount and quantity thresholds' do
      expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts")
      expect(page).to have_link(@bd_1.id)
      expect(page).to have_content(@bd_1.name)
      expect(page).to have_content(@bd_1.threshold)
      expect(page).to have_content(@bd_1.percent_discount)
      expect(page).to have_link(@bd_2.id)
      expect(page).to have_content(@bd_2.name)
      expect(page).to have_content(@bd_2.threshold)
      expect(page).to have_content(@bd_2.percent_discount)
    end

    it 'shows you a button to create a new bulk discount' do
      expect(page).to have_link("New Bulk Discount")
    end

    context 'delete bulk discount' do
      it 'can delete a bulk discount' do
        expect(page).to have_content(@bd_1.name)
        within "#bd-#{@bd_1.id}" do
          expect(page).to have_link("Delete")
          click_on "Delete"
        end
        expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts")
        expect(page).to_not have_content(@bd_1.name)
      end
    end
  end
end