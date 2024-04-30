require 'rails_helper'

describe "getAnimals graphql query root field" do
  context "with an animal in the database" do
    let(:habitat) {
      Habitat.create(name: 'Jungle', environment_description: {temperature_range: [26, 38], features: ['lake', 'trees', 'ferns', 'streams', 'waterfall', 'ground cover']}) }
    let!(:animal) {
      Animal.create(name: 'Robert', species: 'gorilla', habitat: habitat, status: :healthy, info: {dietary_requirements: [{type: 'fruits', quantity: '10lb/day'}], feeding_times: [Time.new(2024, 1, 1, 7, 0, 0), Time.new(2024, 1, 1, 12, 0, 0), Time.new(2024, 1, 1, 19, 0, 0)], favorite_keeper: 'jane' })
    }
    context "with no arguments" do
      let(:query_string) {
        <<-GRAPHQL
          query {
            getAnimals {
              id
              name
              species
              dietaryRequirements {
                type
                quantity
              }
              habitat {
                id
                name
              }
            }
          }
        GRAPHQL
      }
      subject { ZooSchema.execute(query_string).to_h['data']['getAnimals']}

      it "returns the animal" do
        expect(subject).not_to be_empty
        expect(subject.length).to eq 1
        expect(subject.first['name']).to eq animal.name
        expect(subject.first['habitat']['name']).to eq habitat.name
      end
    end

    context "filtering by habitat" do
    end
  end
end
