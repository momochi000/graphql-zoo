class ChangeStringEnumsToInt < ActiveRecord::Migration[7.1]
  def change
    change_column :animals, :status, :integer
    change_column :employees, :role, :integer
  end
end
