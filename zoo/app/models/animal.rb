class Animal < ApplicationRecord
  belongs_to :habitat
  has_many :notes, as: :notable

  accepts_nested_attributes_for :habitat

  enum status: [:healthy, :sick, :injured, :depressed, :needs_attention]

  def dietary_requirements
    return [] unless info.present?
    info["dietary_requirements"]
  end
end
