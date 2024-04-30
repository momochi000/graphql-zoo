# frozen_string_literal: true

module Types
  class HabitatType < Types::BaseObject
    field :id, ID, null: false
    field :name, String
    field :environment_description, GraphQL::Types::JSON
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :animals, [Types::AnimalType]
  end
end
