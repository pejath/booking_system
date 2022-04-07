# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

5.times do
  hotel = Hotel.create(name: Faker::Company.name, rating: rand(1..5))
  hotel.image.attach(io: File.open("#{Rails.root}/app/assets/images/placeholder.png"), filename: 'placeholder')
  # Common User
  User.create(name: Faker::Name.first_name, surname: Faker::Name.last_name, role: 0, email: Faker::Internet.email, password: '111111')
  # Administrator
  User.create(name: Faker::Name.first_name, surname: Faker::Name.last_name, role: 1, email: Faker::Internet.email, password: '111111')
  # Administrator.create(name: Faker::Name.first_name, surname: Faker::Name.last_name, email: Faker::Internet.email)
  # Client.create(name: Faker::Name.first_name, surname: Faker::Name.last_name, email: Faker::Internet.email,
  #               birthdate: Faker::Date.birthday, phone_number: Faker::PhoneNumber.cell_phone_in_e164)
end

30.times do
  apartment = Apartment.create(hotel_id: rand(1..5), apartment_class: rand(0..3), room_number: rand(1000), price: rand(10..1000))
  3.times { apartment.images.attach(io: File.open("#{Rails.root}/app/assets/images/placeholder.png"), filename: 'placeholder') }
end

6.times do
  #new Request
  Request.create(user: User.all.sample, apartment_class: rand(0..3), number_of_beds: rand(1..8), check_in_date:
    Faker::Date.between(from: 5.month.ago, to: Date.today-1), eviction_date: Faker::Date.between(from: Date.today, to: 5.month.from_now))
  #in progress Request
  Request.create(user: User.all.sample, apartment_class: rand(0..3), number_of_beds: rand(1..8), check_in_date:
    Faker::Date.between(from: 5.month.ago, to: Date.today-1), eviction_date: Faker::Date.between(from: Date.today, to: 5.month.from_now), status: 1)
  #approved Request
  Request.create(user: User.all.sample, apartment_class: rand(0..3), number_of_beds: rand(1..8), check_in_date:
    Faker::Date.between(from: 5.month.ago, to: Date.today-1), eviction_date: Faker::Date.between(from: Date.today, to: 5.month.from_now), status: 2)
  #canceled Request
  Request.create(user: User.all.sample, apartment_class: rand(0..3), number_of_beds: rand(1..8), check_in_date:
    Faker::Date.between(from: 5.month.ago, to: Date.today-1), eviction_date: Faker::Date.between(from: Date.today, to: 5.month.from_now), status: 3)
end

Request.all.each do |request|
  Bill.create(request: request, apartment: Apartment.all.sample)
end
