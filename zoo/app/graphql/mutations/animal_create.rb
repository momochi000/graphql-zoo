# frozen_string_literal: true

module Mutations
  class AnimalCreate < BaseMutation
    description "Creates a new animal. This must be passed either a habitat id or a new habitat input HabitatInputType to associate the new animal with the appropriate habitat"

    field :animal, Types::AnimalType, null: false
    field :errors, [Types::AnimalCreateErrorType], null: false

    argument :animal_input, Types::AnimalInputType, required: true

    def resolve(animal_input:)
      animal = Api::CreateAnimal.execute(animal_input)
      { animal: animal }
    rescue Exception => e
      { errors: [e] }
    end
  end
end
