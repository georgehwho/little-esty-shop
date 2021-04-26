require 'rails_helper'

describe 'bulk discount show page' do
  before {
    @merchant = create(:random_merchant)
    @bd_1 = create(:random_bulk_discount, merchant: @merchant)
    @bd_2 = create(:random_bulk_discount, merchant: @merchant)

    visit merchant_dashboard_index_path(@merchant)
    click_on("My Discounts")
  }

  context 'you click on first bulk discount' do
    it 'shows you the name, threshold, and percent discount' do
      click_on(@bd_1.id)
      expect(page).to have_content(@bd_1.name)
      expect(page).to have_content(@bd_1.threshold)
      expect(page).to have_content(@bd_1.percent_discount)
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @bd_1))
    end
  end
end