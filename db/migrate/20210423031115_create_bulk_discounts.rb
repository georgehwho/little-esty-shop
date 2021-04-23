class CreateBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_discounts do |t|
      t.belongs_to :merchant, foreign_key: true
      t.integer :threshold
      t.integer :percent_discount
      t.string :name

      t.timestamps
    end
  end
end
