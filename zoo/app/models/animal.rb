class Animal < ApplicationRecord
  belongs_to :habitat
  has_many :notes, as: :notable

  accepts_nested_attributes_for :habitat

  enum :status, [:healthy, :sick, :injured, :depressed, :needs_attention], default: :healthy

  def dietary_requirements
    return [] unless info.present?
    info["dietary_requirements"]
  end

  def self.needs_attention_statuses
    [:sick, :injured, :depressed, :needs_attention]
  end
end
