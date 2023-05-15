FactoryBot.define do
  factory :market do
    name { Faker::Market.name }
    street { Faker::Market.street }
    city { Faker::Market.city }
    county { Faker::Market.county }
    state { Faker::Market.state }
    zip { Faker::Market.zip }
    lat { Faker::Market.lat }
    lon { Faker::Market.lon }
  end
end