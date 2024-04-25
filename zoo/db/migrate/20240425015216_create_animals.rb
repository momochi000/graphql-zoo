class CreateAnimals < ActiveRecord::Migration[7.1]
  def change
    create_table :animals do |t|
      t.string :status
      t.json :feeding_times
      t.json :info

      t.timestamps
    end
  end
end
