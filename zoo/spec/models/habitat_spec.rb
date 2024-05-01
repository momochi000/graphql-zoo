require 'rails_helper'

RSpec.describe Habitat, type: :model do
  describe "associations" do
    it {should have_many(:animals) }
    it {should have_many(:notes) }
  end
end
