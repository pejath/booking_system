FactoryBot.define do

  factory :hotel do
    name { Faker::Company.name }
    rating { rand(1..5) }
  end

  factory :invalid_hotel, class: Hotel do
    name { nil }
  end
end

