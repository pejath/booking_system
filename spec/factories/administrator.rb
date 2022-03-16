FactoryBot.define do

  factory :administrator do
    name { Faker::Name.first_name }
    surname { Faker::Name.last_name }
    email { Faker::Internet.email }
  end

  factory :invalid_admin, class: Administrator do
    email { nil }
  end
end