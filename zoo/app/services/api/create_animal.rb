module Api
  module CreateAnimal
    class << self
      def execute(create_animal_args)
        if create_animal_args.habitat_id.present?
          animal = Animal.new(**create_animal_args)
          raise Exception.new "Error creating animal: #{animal.errors.to_hash}" unless animal.save
        elsif create_animal_args.habitat.present?
          if habitat = Habitat.where('lower(name) = ?', create_animal_args.habitat.name.downcase).limit(1).first
            animal = Animal.new(**create_animal_args, **{habitat_id: habitat.id, habitat: nil})
            raise Exception.new "Error creating animal: #{animal.errors.to_hash}" unless animal.save
          else
            habitat_attributes = create_animal_args.habitat.to_hash
            environment_description = habitat_attributes[:environment_description]
            habitat_attributes = {
              habitat: nil,
              habitat_attributes: {
                name: habitat_attributes[:name],
                environment_description: environment_description ? JSON.parse(habitat_attributes[:environment_description]) : ""}
            }
            animal = Animal.new(**create_animal_args, **habitat_attributes)
            raise Exception.new "Error creating animal: #{animal.errors.to_hash}" unless animal.save
          end
        else
          raise Exception.new "A habitat must be provided either through a habitat_id or a HabitatInputType"
        end

        animal
      end
    end
  end
end
