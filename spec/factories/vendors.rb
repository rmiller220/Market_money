FactoryBot.define do
  factory :vendor do
    name { Faker::Artist.name }
    description { Faker::Quote.famous_last_words }  
    contact_name { Faker::Sports::Basketball.player }
    contact_phone { Faker::PhoneNumber.phone_number }
    credit_accepted { Faker::Boolean.boolean(true_ratio: 0.7) }
  end
end