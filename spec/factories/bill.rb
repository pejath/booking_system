FactoryBot.define do

  factory :bill do
    association :client, factory: :client

    final_price { rand(100..10000) }
  end

  factory :invalid_bill, class: Bill do
    final_price { nil }
  end
end
