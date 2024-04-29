module GraphQL
  class Animal < GraphQL::Type::Object
    field :id
    field :name
    field :species
    field :habitat_id
    field :habitat

    #def species
    #  p "DEBUG: in GraphQL::Animal. looking at underlying object: #{object}"
    #  object.species
    #end
  end
end
