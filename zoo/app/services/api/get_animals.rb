module Api
  module GetAnimals
    class << self
      def execute(in_habitat: nil, needing_attention: nil, limit: 10)
        if in_habitat.present?
          habitat = in_habitat.to_h
          begin
            if habitat[:id].present?
              query = Habitat.find(habitat[:id]).animals.includes([:habitat, {notes: :author}])
            elsif habitat[:name].present?
              query = Habitat.find_by('lower(name) = ?', habitat[:name].downcase).animals.includes([:habitat, {notes: :author}])
            else
              # TODO: Create an error class
              raise Exception.new("Attempting to filter by habitat but id or name not given")
            end
          rescue
            # TODO: Create an error class
            raise Exception.new("We couldn't find that habitat")
          end
        else
          query = Animal.includes([:habitat, {notes: :author}])
        end

        if needing_attention
          query = query.where(status: Animal.needs_attention_statuses)
        end

        query.limit(limit)
      end
    end
  end
end
