# frozen_string_literal: true

module Types
  class AnimalInputType < Types::BaseInputObject
    argument :id, ID, required: false
    argument :status, AnimalStatusType, required: false
    argument :feeding_times, GraphQL::Types::JSON, required: false
    argument :info, GraphQL::Types::JSON, required: false
    argument :habitat_id, Integer, required: false
    argument :habitat, HabitatInputType, required: false
    argument :name, String, required: false
    argument :species, String, required: false
  end
end
