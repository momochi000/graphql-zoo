require 'rails_helper'

RSpec.describe Animal, type: :model do
  describe "associations" do
    it { should belong_to(:habitat) }
    it { should have_many(:notes) }

    it { should accept_nested_attributes_for(:habitat) }
  end

  describe "enums" do
    it { should define_enum_for(:status) }
  end

  describe "#dietary_requirements" do
    let(:animal) { Animal.new }
    subject { animal.dietary_requirements }

    context "when there are no dietary requirements" do
      it "returns an empty list" do
        expect(subject).to be_empty
      end
    end

    context "when there are dietary requirements" do
      let(:dietary_requirements) { [{type: 'fruits', quantity: '10lb/day'}]}
      let(:animal) { Animal.new(info: {dietary_requirements: dietary_requirements})}

      it "returns the dietary requirements" do
        expect(subject.count).to eq 1
        expect(subject.first["quantity"]).to eq dietary_requirements.first[:quantity]
        expect(subject.first["type"]).to eq dietary_requirements.first[:type]
      end
    end
  end

  describe ".needs_attention_statuses" do
    it "returns the statuses that need attention" do
      statuses = described_class.needs_attention_statuses
      expect(statuses).to include(:sick)
      expect(statuses).to include(:injured)
      expect(statuses).to include(:depressed)
      expect(statuses).to include(:needs_attention)
    end
  end
end
