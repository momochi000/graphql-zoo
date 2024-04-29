# frozen_string_literal: true

module GraphQL
  class ZooSchema < GraphQL::Schema
    load_directory 'sources'
    #load_directory 'objects'

    #query_fields do
    #  field :get_animals, 'Animal', array: true do
    #    argument :in_habitat, String, null: true
    #    argument :needing_attention, :boolean, null: true
    #  end

    #  field :get_animal, 'Animal', null: false do
    #    argument :id, Integer, null: false
    #  end
    #end

    query_fields do
      field :get_animal, ::Animal, null: false do
        argument :id, Integer, null: false
      end
    end

    def get_animal(id:)
      #Animal.includes(:habitat).joins(:habitat).find(id)
      p "DEBUG: in get_animal with id --> #{id}, Animal is --> #{Animal}, ::Animal is ---> #{::Animal}"
      obj = ::Animal.find(id)
      p "DEBUG: found the animal, can i see it's habitat? --> #{obj.habitat}"
      obj
    end

    # Move this code to some api service
    def get_animals(in_habitat:, needing_attention:)
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
