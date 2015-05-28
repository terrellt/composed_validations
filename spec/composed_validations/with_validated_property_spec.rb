require 'spec_helper'

RSpec.describe ComposedValidations::WithValidatedProperty do
  subject { described_class.new(asset, property, validator) }
  let(:asset) { double("Object") }
  let(:property) { :title }
  let(:validator) { double("Validator") }
  let(:result) { double("result") }
  let(:errors) { double("errors_object") }
  before do
    allow(asset).to receive(:title).and_return(result)
    allow(asset).to receive(:errors).and_return(errors)
    allow(asset).to receive(:valid?).and_return(true)
    allow(errors).to receive(:add)
    # Errors isn't blank if it's received add.
    allow(errors).to receive(:blank?) do
      !!!RSpec::Mocks::Matchers::HaveReceived.new(:add).matches?(errors)
    end
    allow(validator).to receive(:message).and_return("is so awful")
  end

  describe "#class" do
    it "should delegate up" do
      expect(subject.class).to eq asset.class
    end
  end
  describe "#valid?" do
    let(:valid) { true }
    let(:valid_result) { subject.valid? }
    before do
      allow(validator).to receive(:valid_value?).with(result).and_return(valid)
      valid_result
    end
    it "should call asset.valid?" do
      expect(asset).to have_received(:valid?)
    end
    context "when validator returns true" do
      it "should not add any errors" do
        expect(errors).not_to have_received(:add)
      end
      it "should return true" do
        expect(valid_result).to eq true
      end
    end
    context "when passing in a ValidatedProperty" do
      let(:property) { ComposedValidations::ValidatedProperty.new(:title, :title_ids) }
      let(:asset) { double("Object", :title_ids => result) }
      context "when validator returns false" do
        let(:valid) { false }
        it "should access one way and add a message for another property" do
          expect(asset).to have_received(:title_ids)
          expect(errors).to have_received(:add).with(:title, "is so awful")
        end
      end
    end
    context "when validator returns false" do
      let(:valid) { false }
      it "should add an error" do
        expect(errors).to have_received(:add).with(property, "is so awful")
      end
      it "should return false" do
        expect(valid_result).to eq false
      end
    end
  end
end
