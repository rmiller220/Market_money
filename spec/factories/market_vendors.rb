FactoryBot.define do
  factory :market_vendor do
    market_id { Faker::MarketVendor.market_id }
    #market_id { association :market }
    #vendor_id { association :vendor }
    vendor_id { Faker::Number.between(from: 1, to: 100) }
  end
end