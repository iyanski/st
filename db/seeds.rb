# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Company.destroy_all
user = User.create(email: "iyanski@gmail.com", first_name: "Ian Bert", last_name: "Tusil")
Company.create(subdomain: "iyanski", domain: "iyanski.dev:3000", user: user)