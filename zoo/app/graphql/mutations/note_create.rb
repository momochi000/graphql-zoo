# frozen_string_literal: true

module Mutations
  class NoteCreate < BaseMutation
    description "Creates a new note"

    field :note, Types::NoteType, null: false
    field :errors, [Types::NoteCreateErrorType]

    argument :note_input, Types::NoteInputType, required: true

    #TODO: Move this logic to api
    def resolve(note_input:)
      note_params = note_input.to_h
      if note_input.note_attachment.present?
        if !note_input.note_attachment.notable_type.present? || !note_input.note_attachment.notable_id.present?
          # TODO: Create an appropriate error
          raise GraphQL::ExecutionError.new "When attaching a note to something, both the type and ID must be present"
        end
        note_params.delete(:note_attachment)
        note_attachment_params = {
          notable_type: note_input.note_attachment.notable_type,
          notable_id: note_input.note_attachment.notable_id,
        }
        note = ::Note.new(**note_params, **note_attachment_params)
        raise GraphQL::ExecutionError.new "Error creating note", extensions: note.errors.to_hash unless note.save

      else
        note = ::Note.new(**note_input)
        raise GraphQL::ExecutionError.new "Error creating note", extensions: note.errors.to_hash unless note.save
      end

      { note: note }
    end
  end
end
