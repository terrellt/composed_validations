require 'spec_helper'
require 'active_model'

RSpec.describe "Or Validations Spec" do
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
    class LengthIsFour
      def valid?(value)
        value.to_s.length == 4
      end

      def message
        "needs to have a length of 4 characters"
      end
    end
  end
  after do
    Object.send(:remove_const, :MyObject)
    Object.send(:remove_const, :ValueIsFrank)
    Object.send(:remove_const, :LengthIsFour)
  end
  let(:my_object) { MyObject.new }
  let(:resource) do
    ComposedValidations::DecorateProperties.new(
      my_object,
      validation_map
    ).run
  end
  context "when using an OR validator" do
    let(:validation_map) do
      { 
        :title => [
          ComposedValidations::OrValidator.new([
            ValueIsFrank.new,
            LengthIsFour.new
          ])
        ]
      }
    end
    it "should fail if both are invalid" do
      expect(resource).not_to be_valid
    end
    it "should succeed if one is valid" do
      resource.title = "Frank"
      expect(resource).to be_valid
    end
    it "should succeed if the other is valid" do
      resource.title = "1234"
      expect(resource).to be_valid
    end
  end
end
