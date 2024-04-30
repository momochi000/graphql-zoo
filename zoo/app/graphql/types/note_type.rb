# frozen_string_literal: true

module Types
  class NoteType < Types::BaseObject
    field :id, ID, null: false
    field :content, String
    field :notable_type, String
    field :notable_id, Integer
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :employee_id, Integer
    field :employee, Types::EmployeeType, null: false, method: :author
  end
end
