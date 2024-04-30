class Habitat < ApplicationRecord
  has_many :animals
  has_many :notes, as: :notable
end
