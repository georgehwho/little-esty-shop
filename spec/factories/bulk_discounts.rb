FactoryBot.define do
  factory :random_bulk_discount, class: BulkDiscount do
    threshold { rand(1..10) }
    percent_discount { rand(10..50) }
    sequence(:name) { |n| "rand_name#{n}" }

    association :merchant, factory: :random_merchant
  end
end
