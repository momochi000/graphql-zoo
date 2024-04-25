class AddEmployeeManagerRelation < ActiveRecord::Migration[7.1]
  def change
    add_column :employees, :manager_id, :bigint

    add_index :employees, :manager_id
    add_foreign_key :employees, :employees, column: :manager_id
  end
end
