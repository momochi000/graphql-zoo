# frozen_string_literal: true
require 'pry'

module Mutations
  class AnimalCreate < BaseMutation
    description "Creates a new animal. This must be passed either a habitat id or a new habitat input HabitatInputType to associate the new animal with the appropriate habitat"

    field :animal, Types::AnimalType, null: false

    argument :animal_input, Types::AnimalInputType, required: true

    # TODO: Move this logic to api
    def resolve(animal_input:)
#      p "DEBUG: in AnimalCreate.resolve. input.name is ----> #{animal_input.name}"
#      p "DEBUG: in AnimalCreate.resolve. input.status is ----> #{animal_input.status}"
#      p "DEBUG: in AnimalCreate.resolve. habitat name is ----> #{animal_input.habitat.name}"
#      p "DEBUG: in AnimalCreate.resolve. habitat environment_description is ----> #{animal_input.habitat.environment_description}"
#      p "DEBUG: in AnimalCreate.resolve. parsing habitat environment_description is ----> #{JSON.parse(animal_input.habitat.environment_description)}"
      if animal_input.habitat_id.present?
#        p "DEBUG: should be here with habitat id present..."
        animal = ::Animal.new(**animal_input)
#        p "DEBUG: new animal=======>"
#        pp animal
#        p "DEBUG: animal valid? ---> #{animal.valid?}"
        raise GraphQL::ExecutionError.new "Error creating animal", extensions: animal.errors.to_hash unless animal.save
      elsif animal_input.habitat.present?
        if habitat = Habitat.where('lower(name) = ?', animal_input.habitat.name.downcase).limit(1).first
          animal = ::Animal.new(**animal_input, **{habitat_id: habitat.id, habitat: nil})
#          p "DEBUG: building new animal with a habitat name "
          raise GraphQL::ExecutionError.new "Error creating animal", extensions: animal.errors.to_hash unless animal.save
        else
#          p "DEBUG: building new animal with new habitat params"
#          p "DEBUG: habitat attributes.... ---> #{animal_input.habitat.to_hash}"
#          binding.pry
          habitat_attributes = animal_input.habitat.to_hash
          environment_description = habitat_attributes[:environment_description]
          habitat_attributes = {
            habitat: nil,
            habitat_attributes: {
              name: habitat_attributes[:name],
              environment_description: environment_description ? JSON.parse(habitat_attributes[:environment_description]) : ""}
          }
          animal = ::Animal.new(**animal_input, **habitat_attributes)
          raise GraphQL::ExecutionError.new "Error creating animal", extensions: animal.errors.to_hash unless animal.save
        end
#        p "DEBUG: animal at the end of the function -------> #{animal}"
      else
        raise GraphQL::ExecutionError.new "A habitat must be provided either through a habitat_id or a HabitatInputType"
      end
      {animal: animal}
    end
  end
end
