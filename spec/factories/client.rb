FactoryBot.define do

  factory :client do
    name { Faker::Name.first_name }
    surname { Faker::Name.last_name }
    email { Faker::Internet.email }
    birthdate { Faker::Date.birthday }
    phone_number { Faker::PhoneNumber.cell_phone_in_e164 }
  end

  factory :invalid_client, class: Client do
    email { nil }
  end
end

