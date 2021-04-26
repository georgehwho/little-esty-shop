require 'rails_helper'

describe 'bulk discount creation' do
  before {
    @merchant = create(:random_merchant)
    @bd_1 = create(:random_bulk_discount, merchant: @merchant)
    @bd_2 = create(:random_bulk_discount, merchant: @merchant)

    visit merchant_dashboard_index_path(@merchant)
    click_on("My Discounts")
    click_on("New Bulk Discount")
  }

  it 'creates a discount' do
    click_on "Create Bulk discount"
    expect(page).to have_content("Error: Threshold can't be blank, Threshold is not a number, Percent discount can't be blank, Percent discount is not a number, Name can't be blank")
    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant))

    fill_in "Name", with: "new name"
    fill_in "Percent discount", with: 5
    fill_in "Threshold", with: 3

    click_on "Create Bulk discount"

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
    expect(page).to have_content("new name")
  end
end