require 'spec_helper'

RSpec.describe ComposedValidations::OrValidator do
  subject { described_class.new(validators) }
  let(:validators) { [ validator_1, validator_2 ] }
  let(:validator_1) { mock_validator(valid: true) }
  let(:validator_2) { mock_validator(valid: true) }

  describe "#valid?" do
    let(:value) { double("value") }
    let(:result) { subject.valid_value?(value) }
    context "when both validators are valid" do
      it "should return true" do
        expect(result).to eq true
      end
    end
    context "when one is valid" do
      let(:validator_2) { mock_validator(valid: false) }
      it "should return true" do
        expect(result).to eq true
      end
    end
    context "when both are invalid" do
      let(:validator_1) { mock_validator(valid: false) }
      let(:validator_2) { mock_validator(valid: false) }
      it "should return false" do
        expect(result).to eq false
      end
    end
    describe "#message" do
      it "should combine the two validators' messages" do
        expect(subject.message).to eq "message or message"
      end
    end
  end

  def mock_validator(valid:)
    i = double("validator")
    allow(i).to receive(:valid_value?).and_return(valid)
    allow(i).to receive(:message).and_return("message")
    i
  end
end
