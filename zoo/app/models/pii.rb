class Pii < ApplicationRecord
  belongs_to :employee

  # Note need to add deterministic: true if we need to query by these fields
  encrypts :first_name
  encrypts :last_name
  encrypts :email
  encrypts :phone
end
