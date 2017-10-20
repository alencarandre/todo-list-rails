# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


User.where(email: "me@pedro.com").first_or_create!(name: "Pedro", password: "123456", password_confirmation: "123456")
User.where(email: "me@amanda.com").first_or_create!(name: "Amanda", password: "123456", password_confirmation: "123456")
User.where(email: "me@joaquina.com").first_or_create!(name: "Joaquina", password: "123456", password_confirmation: "123456")
User.where(email: "me@fernando.com").first_or_create!(name: "Fernando", password: "123456", password_confirmation: "123456")


User.all.each do |user|
  (1..12).each do |i|
    list = user.lists.where(name: "Pokemon to capture #{i}").first_or_create(access_type: :public)

    (1..12).each do |j|
      task = list.tasks.where(name: Faker::Pokemon.name).first_or_create(status: ((i + j) > 10 ? :done : :not_done))
    end
  end
end
