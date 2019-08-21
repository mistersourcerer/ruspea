module Ruspea::Interpreter
  RSpec.describe Parser, "Numbers" do
    subject(:parser) { described_class.new }

    it "recongnizes integers" do
      expect(parser.call("1 420 -2 4_20")).to eq ["", [
        {
          type: Integer,
          content: "1",
          closed: true
        },
        {
          type: Integer,
          content: "420",
          closed: true
        },
        {
          type: Integer,
          content: "-2",
          closed: true
        },
        {
          type: Integer,
          content: "4_20",
          closed: true
        },
      ]]
    end

    it "recognizes floats" do
      expect(parser.call("1.0 4.20 -2.1 4_2.0")).to eq ["", [
        {
          type: Float,
          content: "1.0",
          closed: true
        },
        {
          type: Float,
          content: "4.20",
          closed: true
        },
        {
          type: Float,
          content: "-2.1",
          closed: true
        },
        {
          type: Float,
          content: "4_2.0",
          closed: true
        },
      ]]
    end
  end
end
