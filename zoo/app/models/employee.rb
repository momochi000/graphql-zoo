class Employee < ApplicationRecord
  has_secure_token :auth_token
  has_one :pii
  has_many :reports, class_name: 'Employee', foreign_key: 'manager_id'
  belongs_to :manager, class_name: 'Employee', inverse_of: :reports, optional: true
end
