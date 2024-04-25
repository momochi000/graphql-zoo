class CreateEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :employees do |t|
      t.string :role
      t.json :tasks
      t.string :auth_token

      t.timestamps
    end
    add_index :employees, :auth_token, unique: true
  end
end
