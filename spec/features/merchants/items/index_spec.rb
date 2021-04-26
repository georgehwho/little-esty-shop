require 'rails_helper'

RSpec.describe "Merchant Items Index Page" do
  context "I visit the items index page" do
    it "I see a list of the names of all my items they are links to the items show page" do
      merchant = create(:random_merchant, id: 22)
      merchant_2 = create(:random_merchant, id: 21)
      item_1 = create(:random_item, id: 1, merchant_id: 22)
      item_2 = create(:random_item, id: 2, merchant_id: 22)
      item_3 = create(:random_item, id: 3, merchant_id: 22)
      item_4 = create(:random_item, id: 4, merchant_id: 22)
      item_5 = create(:random_item, id: 5, merchant_id: 22)
      item_6 = create(:random_item, id: 6, merchant_id: 22)
      item_7 = create(:random_item, id: 7, merchant_id: 21)

      visit merchant_items_path(merchant)
      expect(page).to have_content(item_1.name)
      expect(page).to have_content(item_2.name)
      expect(page).to have_content(item_3.name)
      expect(page).to have_content(item_4.name)
      expect(page).to have_content(item_5.name)
      expect(page).to have_content(item_6.name)
      expect(page).to have_link(item_1.name)
      expect(page).to have_link(item_2.name)
      expect(page).to have_link(item_3.name)
      expect(page).to_not have_content(item_7.name)
    end

    it "I see a button to enable or disable each item" do
      merchant = create(:random_merchant, id: 22)
      item_1 = create(:random_item, id: 1, merchant_id: 22, enabled: true)
      item_2 = create(:random_item, id: 2, merchant_id: 22)

      visit merchant_items_path(merchant)

      within '#enabled-items' do
        expect(page).to have_content(item_1.name)
        expect(page).to_not have_content(item_2.name)
        expect(page).to have_button('Disable')
      end

      within '#disabled-items' do
        expect(page).to_not have_content(item_1.name)
        expect(page).to have_content(item_2.name)
        expect(page).to have_button('Enable')
      end
    end

    it "When I click on the disable button the item is no longer there" do
      merchant = create(:random_merchant, id: 22)
      item_1 = create(:random_item, id: 1, merchant_id: 22, enabled: true)
      item_2 = create(:random_item, id: 2, merchant_id: 22)

      visit merchant_items_path(merchant)

      within '#enabled-items' do
        expect(page).to have_content(item_1.name)
        click_on 'Disable'
        expect(current_path).to eq(merchant_items_path(merchant))
        expect(page).to_not have_content(item_1.name)
      end
    end

    it "When I click on the enable button the item is now enabled" do
      merchant = create(:random_merchant, id: 22)
      item_1 = create(:random_item, id: 1, merchant_id: 22, enabled: true)
      item_2 = create(:random_item, id: 2, merchant_id: 22)

      visit merchant_items_path(merchant)

      within '#disabled-items' do
        click_on 'Enable'
        expect(current_path).to eq(merchant_items_path(merchant))
        expect(page).to_not have_content(item_2.name)
      end
    end

    context "Top Items Sections" do
      before :each do
        @merchant = create(:random_merchant, id: 22)
        @item_1 = create(:random_item, id: 1, merchant_id: 22)
        @item_2 = create(:random_item, id: 2, merchant_id: 22)
        @item_3 = create(:random_item, id: 3, merchant_id: 22)
        @item_4 = create(:random_item, id: 4, merchant_id: 22)
        @item_5 = create(:random_item, id: 5, merchant_id: 22)
        @item_6 = create(:random_item, id: 6, merchant_id: 22)

        @customer_1 = create(:random_customer)
        @customer_2 = create(:random_customer)
        @customer_3 = create(:random_customer)
        @customer_4 = create(:random_customer)
        @customer_5 = create(:random_customer)
        @customer_6 = create(:random_customer)

        @invoice_1 = create(:random_invoice, created_at: 'Tue, 20 Apr 2020 20:22:51 UTC +00:00', customer: @customer_1)
        @invoice_2 = create(:random_invoice, created_at: 'Tue, 20 Apr 2021 20:22:51 UTC +00:00', customer: @customer_2)
        @invoice_3 = create(:random_invoice, created_at: 'Tue, 20 Apr 2012 20:22:51 UTC +00:00', customer: @customer_3)
        @invoice_4 = create(:random_invoice, created_at: 'Tue, 20 Apr 2001 20:22:51 UTC +00:00', customer: @customer_4)
        @invoice_5 = create(:random_invoice, created_at: 'Tue, 20 Apr 2002 20:22:51 UTC +00:00', customer: @customer_5)
        @invoice_6 = create(:random_invoice, created_at: 'Tue, 20 Apr 2003 20:22:51 UTC +00:00', customer: @customer_6)

        @invoice_item_1 = create(:random_invoice_item, unit_price: 100, quantity: 10, invoice: @invoice_1, item: @item_1, status: 0)
        @invoice_item_2 = create(:random_invoice_item, unit_price: 90, quantity: 9, invoice: @invoice_2, item: @item_2, status: 1)
        @invoice_item_3 = create(:random_invoice_item, unit_price: 80, quantity: 8, invoice: @invoice_3, item: @item_3, status: 2)
        @invoice_item_4 = create(:random_invoice_item, unit_price: 10, quantity: 1, invoice: @invoice_4, item: @item_4, status: 2)
        @invoice_item_5 = create(:random_invoice_item, unit_price: 70, quantity: 7, invoice: @invoice_5, item: @item_5, status: 2)
        @invoice_item_6 = create(:random_invoice_item, unit_price: 60, quantity: 6, invoice: @invoice_6, item: @item_6, status: 2)

        @transaction_1 = create(:random_transaction, result: 1, invoice: @invoice_1)
        @transaction_2 = create(:random_transaction, result: 1, invoice: @invoice_2)
        @transaction_3 = create(:random_transaction, result: 1, invoice: @invoice_3)
        @transaction_4 = create(:random_transaction, result: 1, invoice: @invoice_4)
        @transaction_5 = create(:random_transaction, result: 1, invoice: @invoice_5)
        @transaction_6 = create(:random_transaction, result: 1, invoice: @invoice_6)
        visit merchant_items_path(@merchant)
      end
      it "I see the names of the top 5 most popular items, ranked by total revenue generated" do

        expect(page).to have_content("Top Items")
        within '.top-items' do
          expect(page).to have_content(@item_1.name)
          expect(page).to have_content(@item_2.name)
          expect(page).to have_content(@item_3.name)
          expect(page).to have_content(@item_5.name)
          expect(page).to have_content(@item_6.name)

          expect(page).to have_content('$1,000.00')
          expect(page).to have_content('$810.00')
          expect(page).to have_content('$640.00')
          expect(page).to have_content('$490.00')
          expect(page).to have_content('$360.00')

          expect(page).to have_content('04/20/20')
          expect(page).to have_content('04/20/21')
          expect(page).to have_content('04/20/12')
          expect(page).to have_content('04/20/02')
          expect(page).to have_content('04/20/03')
        end
      end
    end
  end
end
