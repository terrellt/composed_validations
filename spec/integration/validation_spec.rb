require 'spec_helper'
require 'active_model'

RSpec.describe "Validations Integration Spec" do
  before do
    class MyObject
      include ActiveModel::Model
      attr_accessor :title, :description
    end
    class ValueIsFrank
      def valid?(value)
        value.to_s == "Frank"
      end

      def message
        "needs to be equal to Frank"
      end
    end
    class LengthIsFive
      def valid?(value)
        value.to_s.length == 5
      end

      def message
        "needs to have a length of 5 characters"
      end
    end
  end
  after do
    Object.send(:remove_const, :MyObject)
    Object.send(:remove_const, :ValueIsFrank)
    Object.send(:remove_const, :LengthIsFive)
  end
  let(:my_object) { MyObject.new }
  let(:validation_map) do
    { :title => ValueIsFrank.new }
  end
  let(:resource) do
    ComposedValidations::DecorateProperties.new(
      my_object,
      validation_map
    ).run
  end
  context "when validations are set" do
    it "should use them" do
      expect(resource).not_to be_valid
      expect(resource.errors.messages).to eq ({:title => ["needs to be equal to Frank"]})
    end
    context "and there are multiple validations" do
      let(:validation_map) do
        { 
          :title => [
            ValueIsFrank.new,
            LengthIsFive.new
          ]
        }
      end
      it "should validate them both" do
        expect(resource).not_to be_valid
        expect(resource.errors.messages).to eq ({:title => [
          "needs to be equal to Frank",
          "needs to have a length of 5 characters"
        ]})
      end
      it "should validate one if the other is valid" do
        resource.title = "12345"
        expect(resource).not_to be_valid
        expect(resource.errors.messages).to eq ({:title => ["needs to be equal to Frank"]})
      end
    end
    context "and the values are okay" do
      let(:my_object) do
        m = MyObject.new
        m.title = "Frank"
        m
      end
      it "should be valid" do
        expect(resource).to be_valid
        expect(resource.errors.messages).to be_empty
      end
    end
  end
end
