class RemoveNotNullFromNotable < ActiveRecord::Migration[7.1]
  def up
    change_column :notes, :notable_type, :string, null: true
    change_column :notes, :notable_id, :integer, null: true
  end

  def down
    change_column :notes, :notable_type, :string, null: false
    change_column :notes, :notable_id, :integer, null: false
  end
end
