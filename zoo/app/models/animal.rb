class Animal < ApplicationRecord
  belongs_to :habitat

  enum status: [:healthy, :sick, :injured, :depressed, :needs_attention]

  def dietary_requirements
    info["dietary_requirements"]
  end
end
