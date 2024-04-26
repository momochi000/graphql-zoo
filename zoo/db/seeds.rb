# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

jungle = Habitat.create(name: 'Jungle', environment_description: {temperature_range: [26, 38], features: ['lake', 'trees', 'ferns', 'streams', 'waterfall', 'ground cover']})
savannah = Habitat.create(name: 'Savannah', environment_description: {temperature_range: [20, 30], features: ['grassland', 'baobab trees', 'brush', 'rocky outcroppings', 'watering hole']})
overseer = Employee.create(role: :manager, pii_attributes: {first_name: 'john', last_name: 'smith', email: 'jsmith@sfzoo.com', phone: '555-123-4567'})

Employee.create(
  role: :vet, manager: overseer, tasks: ['health check on freddy the ostrich', 'health check on cleo the cassowary'],
  pii_attributes: {first_name: 'jane', last_name: 'goodall', email: 'jgoodall@sfzoo.com', phone: Faker::PhoneNumber.phone_number}
)
c1 = Employee.create(role: :caretaker, manager: overseer, pii_attributes: {first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, phone: Faker::PhoneNumber.phone_number})
c2 = Employee.create(role: :caretaker, manager: overseer, pii_attributes: {first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, phone: Faker::PhoneNumber.phone_number})

Animal.create(name: 'Robert', species: 'gorilla', habitat: jungle, status: :healthy, info: {dietary_requirements: [{type: 'fruits', quantity: '10lb/day'}], feeding_times: [Time.new(2024, 1, 1, 7, 0, 0), Time.new(2024, 1, 1, 12, 0, 0), Time.new(2024, 1, 1, 19, 0, 0)], favorite_keeper: 'jane' })
cleo = Animal.create(name: 'Cleo', species: 'cassowary', habitat: jungle, status: :sick, info: {dietary_requirements: [{type: 'fruits', quantity: '3lb/day'}, {type: 'mice', quantity: '3/day'}], feeding_times: [Time.new(2024,1,1,6,0,0), Time.new(2024,1,1,11,30,0), Time.new(2024,1,1,17,0,0)], personality: 'touchy'})
Animal.create(name: 'Mindy', species: 'rhinocerous', habitat: savannah, status: :healthy, info: {dietary_requirements: [{type: 'grass/hay', quantity: '120lb/day'}]}, feeding_times: [Time.new(2024,1,1,5,0,0)])
Animal.create(name: 'Jordan', species: 'elephant', habitat: savannah, status: :healthy, info: {dietary_requirements: [{type: 'grass/hay/leaves', quantity: '300lb/day'}]})
Animal.create(name: 'Oliver', species: 'ostrich', habitat: savannah, status: :healthy)
freddy = Animal.create(name: 'Frederick', species: 'ostrich', habitat: savannah, status: :injured)

Note.create(content: "Noticed that freddy is favoring his left leg while running. Didn't see any obvious signs of blood but needs a closer look", author: c1, notable: freddy)
Note.create(content: "Cleo is looking a little under the weather. She is sneezing and has a runny beak", author: c2, notable: cleo)
Note.create(content: "The watering hole needs to have the water changed out", author: c1, notable: savannah)
