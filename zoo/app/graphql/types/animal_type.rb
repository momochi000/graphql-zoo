# frozen_string_literal: true

module Types
  class AnimalType < Types::BaseObject
    field :id, ID, null: false
    field :status, Integer
    field :feeding_times, GraphQL::Types::JSON
    field :info, GraphQL::Types::JSON
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :habitat_id, Integer
    field :habitat, Types::HabitatType
    field :name, String
    field :species, String
    field :dietary_requirements, [Types::DietaryRequirementType]
  end
end
