class CreateHabitats < ActiveRecord::Migration[7.1]
  def change
    create_table :habitats do |t|
      t.string :name
      t.json :environment_description

      t.timestamps
    end
  end
end
