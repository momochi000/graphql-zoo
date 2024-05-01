# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :get_animal, Types::AnimalType, null: false do
      argument :id, ID, required: true, description: "Get a specific animal by id."
    end

    def get_animal(id:)
      Animal.find(id)
    end

    field :get_animals, Types::AnimalsPayloadType, null: false do
      description "Return a list of animals. optionally filter by habitat with argument `in_habitat`. Filter for animals which need attention with `needing_attention`"

      argument :in_habitat, InHabitatInputType, required: false
      argument :needing_attention, Boolean, required: false
      argument :limit, Integer, required: false
    end

    def get_animals(**args)
      {animals: Api::GetAnimals.execute(**args.to_h)}
    rescue Exception => e
      {errors: [e]}
    end
  end
end
