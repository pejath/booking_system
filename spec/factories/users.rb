FactoryBot.define do
  factory :user do
    name { "MyString" }
    surname { "MyString" }
    email { "MyString" }
    birthdate { "2022-04-06" }
    phone_number { "MyString" }
    role { 1 }
  end
end
