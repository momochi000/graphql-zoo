# frozen_string_literal: true

module Types
  class NoteInputType < Types::BaseInputObject
    argument :content, String, required: true
    argument :note_attachment, Types::NotableInputType, required: false
    argument :employee_id, Integer, required: false
  end
end
