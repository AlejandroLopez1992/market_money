FactoryBot.define do
  factory :vendor do
    name { Faker::Commerce.vendor }
    description { Faker::Company.catch_phrase }
    contact_name { Faker::Name.name }
    contact_phone { Faker::PhoneNumber.cell_phone }
    credit_accepted { Faker::Boolean.boolean }
  end
end
