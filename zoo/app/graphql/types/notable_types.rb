module Types
  class NotableTypes < Types::BaseEnum
    description "The valid types which a note may be attached to"

    value "ANIMAL", value: "Animal"
    value "HABITAT", value: "Habitat"
  end
end

