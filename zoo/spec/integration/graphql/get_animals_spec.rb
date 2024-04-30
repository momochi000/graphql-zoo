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
      let(:employee) { Employee.create(role: :caretaker, pii_attributes: {first_name: 'Testy', last_name: 'McTesterson'})}
      let(:query_string) {
        <<-GRAPHQL
          query {
            getAnimals {
              animals {
                id
                name
                species
                status
                notes {
                  content
                  employee {
                    id
                    role
                  }
                }
                dietaryRequirements {
                  type
                  quantity
                }
                habitat {
                  id
                  name
                  notes {
                    content
                    employee {
                      id
                    }
                  }
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
      it "includes the dietary requirements" do
        expect(output.first['dietaryRequirements'].length).to eq 1
        expect(output.first['dietaryRequirements'].first['type']).to eq "fruits"
        expect(output.first['dietaryRequirements'].first['quantity']).to eq "10lb/day"
      end

      context "when a note is attached to an animal" do
        let!(:note) { Note.create(content: 'A test note', author: employee, notable: animal )}

        it "includes any notes attached to the animal" do
          expect(output.first['notes'].length).to eq 1
        end

        it "includes the employee who created the notes which are attached to the animal" do
          expect(output.first['notes'].first['content']).to eq note.content
          expect(output.first['notes'].first['employee']['id'].to_i).to eq employee.id
          expect(output.first['notes'].first['employee']['role']).to eq employee.role
        end
      end

      context "when a note is attached to a habitat" do
        let!(:note) { Note.create(content: 'A test note about the habitat', author: employee, notable: habitat )}

        it "includes any notes attached to the habitat" do
          expect(output.first['habitat']['notes'].length).to eq 1
          expect(output.first['habitat']['notes'].first['content']).to eq note.content
          expect(output.first['habitat']['notes'].first['employee']['id'].to_i).to eq employee.id
        end
      end
    end

    context "filtering by habitat" do
      let(:query_string) {
        <<-GRAPHQL
          query {
            getAnimals(#{filter_args}) {
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
        let(:filter_args) {"inHabitat: {name:\"#{habitat.name}\"}"}

        it "returns the animal" do
          expect(output).not_to be_empty
          expect(output.length).to eq 1
          expect(output.first['name']).to eq animal.name
        end
      end

      context "using the id of the animal's habitat" do
        let(:filter_args) {"inHabitat: {id:#{habitat.id}}"}

        it "returns the animal" do
          expect(output).not_to be_empty
          expect(output.length).to eq 1
          expect(output.first['name']).to eq animal.name
        end
      end

      context "using a non-existing habitat" do
        let(:filter_args) {"inHabitat: {name:\"Desert\"}"}

        it "returns an error" do
          errors = subject['data']['getAnimals']['errors']
          expect(errors).not_to be_empty
        end
      end
    end

    context "filtering by animals that need attention" do
      let(:filter_args) { "needingAttention: true" }
      let(:query_string) {
        <<-GRAPHQL
          query {
            getAnimals(#{filter_args}) {
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

      it "returns no animals" do
        expect(output).to be_empty
      end

      context "when an animal needs attention" do
        let!(:sick_animal) {
          Animal.create(name: 'Frederick', species: 'ostrich', habitat: habitat, status: :injured)
        }
        it "returns the injured animal" do
          expect(output).not_to be_empty
          expect(output.length).to eq 1
          expect(output.first['name']).to eq sick_animal.name
        end
      end
    end
  end
end
