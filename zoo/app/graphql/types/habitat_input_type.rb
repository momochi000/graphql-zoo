# frozen_string_literal: true

module Types
  class HabitatInputType < Types::BaseInputObject
    argument :id, ID, required: false
    argument :name, String, required: true
    argument :environment_description, GraphQL::Types::JSON, required: false
  end
end
