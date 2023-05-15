FactoryBot.define do
  factory :vendor do
    name { Faker::Artist.name }
    description { Faker::Quote.famous_last_words }  
    contact_name { Faker::Vendor.contact_name }
    contact_phone { Faker::Sports::Basketball.player }
    credit_accepted { Faker::Boolean.boolean(true_ratio: 0.7) }
  end
end