require 'rails_helper'

describe "animalCreate graphql query root field" do
  let(:new_animal_name) { "cody" }
  let(:new_animal_species) { "giraffe" }
  let(:new_habitat_name) { "savannah" }
  subject { ZooSchema.execute(query_string).to_h }

  context "Creating an animal with a new habitat" do
    let(:query_string) {
      <<-GRAPHQL
        mutation {
          animalCreate(input:{
            animalInput:{
              status: healthy
              name: "#{new_animal_name}"
              species: "#{new_animal_species}"
              habitat:{
                name:"#{new_habitat_name}"
                environmentDescription: "{}"
              }
            }
          }) {
            animal {
              id
              name
              species
              habitat {
                id
                name
              }
            }
          }
        }
      GRAPHQL
    }

    it "creates the new animal" do
      expect { subject }.to change { Animal.count }.by(1)
    end
    it "creates the new habitat" do
      expect { subject }.to change { Habitat.count }.by(1)
    end
    it "creates the animal in the correct habitat" do
      output = subject["data"]["animalCreate"]["animal"]
      expect(output["name"]).to eq new_animal_name
      expect(output["species"]).to eq new_animal_species
      expect(output["habitat"]["name"]).to eq new_habitat_name
      animal = Animal.find(output["id"])
      expect(animal.name).to eq new_animal_name
      expect(animal.species).to eq new_animal_species
      expect(animal.habitat.name).to eq new_habitat_name
    end
  end

  context "when a habitat exists" do
    let(:existing_habitat_name) { "Jungle" }
    let(:existing_habitat_environment_description)  {
      {temperature_range: [26, 38], features: ['lake', 'trees', 'ferns', 'streams', 'waterfall', 'ground cover']}
    }
    let!(:existing_habitat) {
      Habitat.create(
        name: existing_habitat_name,
        environment_description: existing_habitat_environment_description)
    }

    context "when passing in the existing habitat id" do
      let(:query_string) {
        <<-GRAPHQL
          mutation {
            animalCreate(input:{
              animalInput:{
                status: healthy
                name: "#{new_animal_name}"
                species: "#{new_animal_species}"
                habitatId: #{existing_habitat.id}
              }
            }) {
              animal {
                id
                name
                species
                habitat {
                  id
                  name
                }
              }
            }
          }
        GRAPHQL
      }

      it "creates the new animal" do
        expect { subject }.to change { Animal.count }.by(1)
      end
      it "doesn't create a new habitat" do
        expect { subject }.not_to change { Habitat.count }
      end
      it "associates the animal with the habitat" do
        output = subject["data"]["animalCreate"]["animal"]
        output["habitat"]["name"] = 'Jungle'
        animal = Animal.find(output["id"])
        expect(animal.habitat_id).to eq existing_habitat.id
      end
    end

    context "when passing in the existing habitat name" do
      let(:query_string) {
        <<-GRAPHQL
          mutation {
            animalCreate(input:{
              animalInput:{
                status: healthy
                name: "#{new_animal_name}"
                species: "#{new_animal_species}"
                habitat: {
                  name: "#{existing_habitat_name}"
                }
              }
            }) {
              animal {
                id
                name
                species
                habitat {
                  id
                  name
                }
              }
            }
          }
        GRAPHQL
      }

      it "creates the new animal" do
        expect { subject }.to change { Animal.count }.by(1)
      end
      it "doesn't create a new habitat" do
        expect { subject }.not_to change { Habitat.count }
      end
      it "associates the animal with the habitat" do
        output = subject["data"]["animalCreate"]["animal"]
        output["habitat"]["name"] = 'Jungle'
        animal = Animal.find(output["id"])
        expect(animal.habitat_id).to eq existing_habitat.id
      end

      context "when the habitat name doesn't match the case of the existing one" do
        let(:query_string) {
          <<-GRAPHQL
            mutation {
              animalCreate(input:{
                animalInput:{
                  status: healthy
                  name: "#{new_animal_name}"
                  species: "#{new_animal_species}"
                  habitat: {
                    name: "#{existing_habitat_name.upcase}"
                  }
                }
              }) {
                animal {
                  id
                  name
                  species
                  habitat {
                    id
                    name
                  }
                }
              }
            }
          GRAPHQL
        }

        it "creates the new animal" do
          expect { subject }.to change { Animal.count }.by(1)
        end
        it "doesn't create a new habitat" do
          expect { subject }.not_to change { Habitat.count }
        end
        it "associates the animal with the habitat" do
          output = subject["data"]["animalCreate"]["animal"]
          output["habitat"]["name"] = 'Jungle'
          animal = Animal.find(output["id"])
          expect(animal.habitat_id).to eq existing_habitat.id
        end
      end
    end

    context "when passing in a non-existing habitat name" do
      let(:new_habitat_name) { "desert" }
      let(:query_string) {
        <<-GRAPHQL
          mutation {
            animalCreate(input:{
              animalInput:{
                status: healthy
                name: "#{new_animal_name}"
                species: "#{new_animal_species}"
                habitat: {
                  name: "#{new_habitat_name}"
                }
              }
            }) {
              animal {
                id
                name
                species
                habitat {
                  id
                  name
                }
              }
            }
          }
        GRAPHQL
      }

      it "creates the new animal" do
        expect { subject }.to change { Animal.count }.by(1)
      end
      it "creates a new habitat" do
        expect { subject }.to change { Habitat.count }.by(1)
      end
      it "associates the animal with the habitat" do
        output = subject["data"]["animalCreate"]["animal"]
        output["habitat"]["name"] = 'Jungle'
        animal = Animal.find(output["id"])
        expect(animal.habitat_id).not_to eq existing_habitat.id
        expect(animal.habitat.name).to eq new_habitat_name
      end
    end
  end
end
