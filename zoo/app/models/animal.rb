class Animal < ApplicationRecord
  belongs_to :habitat

  enum status: [:healthy, :sick, :injured, :depressed]
end
