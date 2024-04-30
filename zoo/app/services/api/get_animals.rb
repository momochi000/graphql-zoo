module Api
  module GetAnimals
    class << self
      def execute(in_habitat: nil, needing_attention: nil)
#        p "DEBUG: in Api::GetAnimals"
        if in_habitat.present?
          habitat = in_habitat.to_h
##          p "DEBUG: habitat data ---> #{habitat}"
          begin
            if habitat[:id].present?
              query = Habitat.find(habitat[:id]).animals.includes(:habitat)
            elsif habitat[:name].present?
              query = Habitat.find_by('lower(name) = ?', habitat[:name].downcase).animals.includes(:habitat)
            else
              # TODO: Error
            end
          rescue
            # TODO: Create an error class
            raise "We couldn't find that habitat"
          end
        else
          query = Animal.includes(:habitat)
        end
        if needing_attention
          query = query.where('status in ?', [:sick, :injured, :needs_attention, :depressed])
        end

        query.limit(10) # TODO: Implement some kind of default here
      end
    end
  end
end
