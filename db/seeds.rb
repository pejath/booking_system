# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

5.times do
  Hotel.create(name: Faker::Company.name, rating: rand(1..5))
  Administrator.create(name: Faker::Name.first_name, surname: Faker::Name.last_name, email: Faker::Internet.email)
  Client.create(name: Faker::Name.first_name, surname: Faker::Name.last_name, email: Faker::Internet.email,
                birthdate: Faker::Date.birthday, phone_number: Faker::PhoneNumber.cell_phone_in_e164)
end

30.times do
  Apartment.create(hotel_id: rand(1..5), apartment_class: rand(0..3), room_number: rand(1000), price: rand(10..1000))
end

6.times do
  Request.create(client: Client.all.sample, apartment_class: rand(0..3), number_of_beds: rand(1..8), check_in_date:
    Faker::Date.between(from: 2.years.ago, to: Date.today-1), eviction_date: Faker::Date.between(from: Date.today, to: 5.month.from_now))
end

Request.all.each do |request|
  Bill.final_price(request, Apartment.all.sample)
end
