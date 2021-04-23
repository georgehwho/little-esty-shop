class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates :threshold, presence: true, numericality: { only_integer: true }
  validates :percent_discount, presence: true, numericality: { only_integer: true }
  validates_presence_of :name
end
