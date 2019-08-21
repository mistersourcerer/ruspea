module Ruspea::Interpreter
  RSpec.describe Parser do
    subject(:parser) { described_class.new }

    it "ignores spaces and commas" do
      expect(parser.call(", , ,")).to eq []
    end

    it "ignores blank lines" do
      expect(parser.call("\n\n")).to eq []
    end
  end
end
