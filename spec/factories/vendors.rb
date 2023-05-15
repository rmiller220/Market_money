FactoryBot.define do
  factory :vendor do
    name { Faker::Vendor.name }
    description { Faker::Vendor.description }
    contact_name { Faker::Vendor.contact_name }
    contact_phone { Faker::Vendor.contact_phone }
    credit_accepted { Faker::Vendor.credit_accepted }
  end
end