class AnimalBelongsToHabitat < ActiveRecord::Migration[7.1]
  def change
    add_reference :animals, :habitat, foreign_key: true, index: true
  end
end
