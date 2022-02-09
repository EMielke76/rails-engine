FactoryBot.define do
  factory :merchant do
    name { Faker::Name.name}
  end

  factory :merchant_with_items do
    transient do
      item_count {2}
    end
    after(:create) do |merchant, evaluator|
      create_list(:item, evaluator.item_count, merchant: merchant)
    end
  end
end
