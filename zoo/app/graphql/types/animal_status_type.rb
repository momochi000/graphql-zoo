# frozen_string_literal: true

module Types
  class AnimalStatusType < Types::BaseEnum
    description "Animal status enum"

    Animal.statuses.each do |status, value|
      value status, value: value
    end
  end
end
