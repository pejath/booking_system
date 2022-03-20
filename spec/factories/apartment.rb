FactoryBot.define do

  factory :apartment do
    association :hotel, factory: :hotel

    apartment_class { %w[A B C Luxe].sample }
    room_number { rand(1000) }
    price { rand(10..1000) }
  end

  factory :invalid_apartment, class: Apartment do
    room_number { nil }
    apartment_class { 'C' }
  end
end
