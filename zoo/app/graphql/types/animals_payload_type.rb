module Types
  class AnimalsPayloadType < Types::BaseObject
    field :animals, [Types::AnimalType]
    field :errors, [Types::GetAnimalsErrorType]
  end
end
