module Types
  class NotableInputType < Types::BaseInputObject
    description "The object that a note may be attached to. It is designated by both it's type and an ID"

    argument :notable_type, NotableTypes, required: false
    argument :notable_id, Integer, required: false
  end
end
