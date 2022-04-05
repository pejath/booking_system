FactoryBot.define do

  factory :apartment do
    association :hotel, factory: :hotel

    apartment_class { %w[B C A Luxe].sample }
    room_number { rand(1..1000) }
    price { rand(100..1000) }
  end

  factory :invalid_apartment, class: Apartment do
    room_number { nil }
  end
end
