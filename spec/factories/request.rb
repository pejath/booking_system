FactoryBot.define do

  factory :request do
    association :client, factory: :client
    apartment_class { %w[A B C Luxe].sample }
    number_of_beds { rand(1..8) }
    check_in_date { Faker::Date.between(from: 2.years.ago, to: Date.today - 1) }
    eviction_date { Faker::Date.between(from: Date.today, to: 5.month.from_now) }
  end

  factory :invalid_request, class: Request do
    number_of_beds { nil }
  end
end


