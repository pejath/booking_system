FactoryBot.define do

  factory :bill do
    association :request, factory: :request
    association :apartment, factory: :apartment

    final_price { rand(10..10000) }
  end

  factory :invalid_bill, class: Bill do
    association :request, factory: :request
    association :apartment, factory: :apartment

    after(:build) do |bill|
      bill.final_price = -1
    end
  end
end
