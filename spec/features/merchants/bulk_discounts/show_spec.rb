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
    before {
      click_on(@bd_1.id)
    }
    it 'shows you the name, threshold, and percent discount' do
      expect(page).to have_content(@bd_1.name)
      expect(page).to have_content(@bd_1.threshold)
      expect(page).to have_content(@bd_1.percent_discount)
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @bd_1))
    end

    it 'shows you a edit link' do
      expect(page).to have_link("Edit Bulk Discount")
    end
  end
end