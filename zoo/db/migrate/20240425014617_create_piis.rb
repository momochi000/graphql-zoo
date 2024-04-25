class CreatePiis < ActiveRecord::Migration[7.1]
  def change
    create_table :piis do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.references :employee, null: false, foreign_key: true

      t.timestamps
    end
  end
end
