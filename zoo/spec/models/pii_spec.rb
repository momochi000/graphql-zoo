require 'rails_helper'

RSpec.describe Pii, type: :model do
  describe "associations" do
    it { should belong_to(:employee) }
  end
  describe "encryption" do
    it { should encrypt(:first_name) }
    it { should encrypt(:last_name) }
    it { should encrypt(:email) }
    it { should encrypt(:phone) }
  end
end
