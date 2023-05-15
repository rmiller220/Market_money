FactoryBot.define do
  factory :market_vendor do
    market_id { Faker::MarketVendor.market_id }
    vendor_id { Faker::Number.between(from: 1, to: 100) }
  end
end