require 'rails_helper'

RSpec.describe Note, type: :model do
  describe "associations" do
    it { should belong_to(:notable).required(false) }
    it { should belong_to(:author).class_name('Employee') }
  end
end
