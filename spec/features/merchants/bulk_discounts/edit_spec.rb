require 'rails_helper'

describe 'merchants bulk discounts' do
  before {
    @merchant = create(:random_merchant)
    @bd_1 = create(:random_bulk_discount, merchant: @merchant)
    @bd_2 = create(:random_bulk_discount, merchant: @merchant)

    visit merchant_dashboard_index_path(@merchant)
    click_on("My Discounts")
    click_on(@bd_1.id)
    click_on("Edit Bulk Discount")
  }

  context 'you are on the merchant edit page' do
    it 'has the correct path' do
      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @bd_1))
    end

    it 'has the current attributes filled out' do
      expect(find_field('Name').value).to eq(@bd_1.name)
      expect(find_field('Percent discount').value).to eq(@bd_1.percent_discount.to_s)
      expect(find_field('Threshold').value).to eq(@bd_1.threshold.to_s)
    end

    it 'saves updates properly' do
      fill_in 'Name', with: 'test'
      click_on 'Update Bulk discount'
      expect(page).to have_content('test')
    end

    it 'throws an error properly' do
      fill_in 'Name', with: ''
      click_on 'Update Bulk discount'
      expect(page).to have_content("Error: Name can't be blank")
    end
  end
end