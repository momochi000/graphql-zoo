# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :note_create, mutation: Mutations::NoteCreate
    field :animal_create, mutation: Mutations::AnimalCreate
  end
end
