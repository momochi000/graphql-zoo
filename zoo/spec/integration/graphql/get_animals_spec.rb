require 'rails_helper'

describe "getAnimals graphql query root field" do
  subject { ZooSchema.execute(query_string).to_h}
  let(:output) { subject['data']['getAnimals']['animals']}
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
              animals {
                id
                name
                species
                status
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
          }
        GRAPHQL
      }

      it "returns the animal" do
        expect(output).not_to be_empty
        expect(output.length).to eq 1
        expect(output.first['name']).to eq animal.name
        expect(output.first['habitat']['name']).to eq habitat.name
      end
      it "lists the status as a string" do
        expect(output.first['status']).to eq "healthy"
      end
    end

    context "filtering by habitat" do
      let(:query_string) {
        <<-GRAPHQL
          query {
            getAnimals(#{habitat_filter}) {
              errors {
                message
              }
              animals {
                id
                name
                species
                dietaryRequirements {
                  type
                  quantity
                }
              }
            }
          }
        GRAPHQL
      }
      context "using the name of the animal's habitat" do
        let(:habitat_filter) {"inHabitat: {name:\"#{habitat.name}\"}"}

        it "returns the animal" do
          expect(output).not_to be_empty
          expect(output.length).to eq 1
          expect(output.first['name']).to eq animal.name
        end
      end

      context "using the id of the animal's habitat" do
        let(:habitat_filter) {"inHabitat: {id:#{habitat.id}}"}

        it "returns the animal" do
          expect(output).not_to be_empty
          expect(output.length).to eq 1
          expect(output.first['name']).to eq animal.name
        end
      end

      context "using a non-existing habitat" do
        let(:habitat_filter) {"inHabitat: {name:\"Desert\"}"}

        it "returns an error" do
          errors = subject['data']['getAnimals']['errors']
          expect(errors).not_to be_empty
        end
      end
    end
  end
end
