require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "relationships" do
    it {should have_many :bulk_discounts}
    it {should have_many :invoices}
    it {should have_many :invoice_items}
    it {should belong_to :merchant}
  end

  describe "validations" do
    it {should validate_presence_of :name}
    it {should validate_presence_of :description}
    it {should validate_presence_of :unit_price}
    it {should validate_numericality_of :unit_price}
  end

  describe "instance methods" do
    describe "#top_sales_day" do
      it "returns the created_at invoice date for highest revenue day of item" do
        item_1 = create(:random_item, id: 1)
        invoice_1 = create(:random_invoice, created_at: 'Tue, 20 Apr 2020 20:22:51 UTC +00:00')
        invoice_2 = create(:random_invoice, created_at: 'Tue, 20 Apr 2021 20:22:51 UTC +00:00')
        invoice_3 = create(:random_invoice, created_at: 'Tue, 20 Apr 2012 20:22:51 UTC +00:00')
        invoice_4 = create(:random_invoice, created_at: 'Tue, 20 Apr 2001 20:22:51 UTC +00:00')
        invoice_item_1 = create(:random_invoice_item, unit_price: 100, quantity: 10, invoice: invoice_1, item: item_1, status: 0)
        invoice_item_2 = create(:random_invoice_item, unit_price: 100, quantity: 4, invoice: invoice_2, item: item_1, status: 0)
        invoice_item_3 = create(:random_invoice_item, unit_price: 100, quantity: 8, invoice: invoice_3, item: item_1, status: 0)
        invoice_item_4 = create(:random_invoice_item, unit_price: 100, quantity: 7, invoice: invoice_4, item: item_1, status: 0)
        expect(item_1.top_sales_day).to eq('04/20/20')
      end
    end
  end

  describe "class methods" do
    describe ".not_shipped" do
      it "returns items that haven't been shipped" do
        item_1 = create(:random_item, id: 1)
        item_2 = create(:random_item, id: 2)
        item_3 = create(:random_item, id: 3)
        invoice_item_1 = create(:random_invoice_item, item: item_1, status: 0)
        invoice_item_2 = create(:random_invoice_item, item: item_2, status: 1)
        invoice_item_3 = create(:random_invoice_item, item: item_3, status: 2)

        expect(Item.not_shipped).to eq([item_1, item_2])
      end
    end

    describe ".items_enabled" do
      it "returns items that are enabled" do
        item_1 = create(:random_item, id: 1, enabled: true)
        item_2 = create(:random_item, id: 2, enabled: true)
        item_3 = create(:random_item, id: 3, enabled: false)
        expect(Item.items_enabled).to eq([item_1, item_2])
      end
    end

    describe ".items_disabled" do
      it "returns items that are disabled" do
        item_1 = create(:random_item, id: 1, enabled: true)
        item_2 = create(:random_item, id: 2, enabled: true)
        item_3 = create(:random_item, id: 3, enabled: false)
        expect(Item.items_disabled).to eq([item_3])
      end
    end
  end
end
