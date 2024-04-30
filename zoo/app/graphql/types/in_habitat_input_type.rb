module Types
  class InHabitatInputType < Types::BaseInputObject
    description "When filtering for animals in a habitat, can specify the id of the habitat or name"

    argument :id, ID, required: false
    argument :name, String, required: false
  end
end
