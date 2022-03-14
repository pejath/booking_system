FactoryBot.define do

  factory :bill do
    association :request, factory: :request
    association :apartment, factory: :apartment

    final_price { rand(0..10000) }
  end

  factory :invalid_bill, class: Bill do
    final_price { nil }
  end
end
