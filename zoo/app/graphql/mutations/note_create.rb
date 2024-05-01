# frozen_string_literal: true

module Mutations
  class NoteCreate < BaseMutation
    description "Creates a new note. needs an employee_id to indicate the "

    field :note, Types::NoteType, null: false
    field :errors, [Types::NoteCreateErrorType]

    argument :note_input, Types::NoteInputType, required: true

    #TODO: Move this logic to api
    def resolve(note_input:)
      { note: Api::CreateNote.execute(note_input.to_h) }
    rescue Exception => e
      { errors: [e] }
    end
  end
end
