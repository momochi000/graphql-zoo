class AddNameSpeciesToAnimals < ActiveRecord::Migration[7.1]
  def change
    add_column :animals, :name, :string
    add_column :animals, :species, :string
  end
end
