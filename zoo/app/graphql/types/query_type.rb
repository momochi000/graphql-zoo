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

    # TODO: remove me
    #field :test_field, String, null: false,
    #  description: "An example field added by the generator"
    #def test_field
    #  "Hello World!"
    #end

    field :get_animal, Types::AnimalType, null: false do
      argument :id, ID, required: true, description: "Get a specific animal."
    end

    def get_animal(id:)
      Animal.find(id)
    end

    field :get_animals, [Types::AnimalType], null: false do
      description "Does this work?"
      argument :in_habitat, String, required: false
      argument :needing_attention, Boolean, required: false
    end

    def get_animals(in_habitat: nil, needing_attention: nil)
      p "DEBUG: animals_in_habitat: is this getting called?? habitat name is ---> #{in_habitat}, needing_attention is --> #{needing_attention}"
      if in_habitat
        query = Habitat.find_by('lower(name) = ?', in_habitat.downcase).animals.includes(:habitat)
        p "DEBUG: output of get_animals ---> #{result}"
      else
        query = Animal.includes(:habitat)
      end
      if needing_attention
        query = query.where('status in ?', [:sick, :injured, :needs_attention, :depressed])
      end

      query.limit(10) # TODO: Implement some kind of default here
    rescue Exception
      p "DEBUG: error here"
      [] # or however you want to handle errors
    end
  end
end
