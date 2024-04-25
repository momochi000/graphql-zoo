class AddAuthorToNotes < ActiveRecord::Migration[7.1]
  def change
    add_reference :notes, :employee, foreign_key: true, index: true
  end
end
