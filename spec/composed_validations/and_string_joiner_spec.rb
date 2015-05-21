require 'spec_helper'

RSpec.describe ComposedValidations::AndStringJoiner do
  subject { described_class.new(*strings) }
  context "when there's two strings" do
    let(:strings) { ["one", "two"] }
    it "should join with and" do
      expect(subject.to_s).to eq "one and two"
    end
  end
  context "when there's three strings" do
    let(:strings) { ["one", "two", "three"] }
    it "should join with a comma and and" do
      expect(subject.to_s).to eq "one, two and three"
    end
  end
  context "when there's four strings" do
    let(:strings) { ["one", "two", "three", "four"] }
    it "should join nicely" do
      expect(subject.to_s).to eq "one, two, three and four"
    end
  end
end
