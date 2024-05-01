require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe "associations" do
    it { should belong_to(:manager).class_name('Employee').required(false) }
    it { should have_one(:pii) }
    it { should have_many(:reports).class_name('Employee') }
    it { should have_many(:notes) }

    it { should accept_nested_attributes_for(:pii)}
  end

  describe "secure token" do
    it { should have_secure_token(:auth_token)}
  end

  describe "enums" do
    it { should define_enum_for(:role) }
  end
end
