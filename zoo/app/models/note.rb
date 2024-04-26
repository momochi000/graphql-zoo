class Note < ApplicationRecord
  belongs_to :author, class_name: 'Employee', foreign_key: :employee_id
  belongs_to :notable, polymorphic: true
end
