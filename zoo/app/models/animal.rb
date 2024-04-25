class Animal < ApplicationRecord
  belongs_to :habitiat

  enum status: [:healthy, :sick, :injured, :depressed]
end
