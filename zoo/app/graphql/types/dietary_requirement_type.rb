# frozen_string_literal: true

module Types
  class DietaryRequirementType < Types::BaseObject
    field :type, String
    field :quantity, String
  end
end
