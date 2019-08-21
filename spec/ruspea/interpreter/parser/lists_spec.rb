module Ruspea::Interpreter
  RSpec.describe Parser, "Lists" do
    subject(:parser) { described_class.new }
    subject(:list_type) { Ruspea::Runtime::List }
    subject(:sym_type) { Ruspea::Runtime::Sym }

    it "recongizes a list" do
      expect(parser.call("(1 \"2\", 3\n4.20)")).to eq ["", [
        {
          closed: true,
          type: list_type,
          content: [
            {closed: true, type: Integer, content: "1"},
            {closed: true, type: String, content: "2"},
            {closed: true, type: Integer, content: "3"},
            {closed: true, type: Float, content: "4.20"},
          ]
        }
      ]]
    end

    it "recognizes nested lists" do
      code = "((2 3 4) 1 (5 (6)))"
      expect(parser.call(code)).to eq ["", [
        {
          closed: true,
          type: list_type,
          content: [
            {
              closed: true,
              type: list_type,
              content: [
                {closed: true, type: Integer, content: "2"},
                {closed: true, type: Integer, content: "3"},
                {closed: true, type: Integer, content: "4"},
              ]
            },
            {closed: true, type: Integer, content: "1"},
            {
              closed: true,
              type: list_type,
              content: [
                {closed: true, type: Integer, content: "5"},
                {
                  closed: true,
                  type: list_type,
                  content: [
                    {closed: true, type: Integer, content: "6"},
                  ]
                }
              ]
            }
          ]
        }
      ]]
    end

    it "recongizes an open list" do
      expect(parser.call("(1 (2)")).to eq ["", [
        {
          closed: false,
          type: list_type,
          content: [
            {closed: true, type: Integer, content: "1"},
            {
              closed: true,
              type: list_type,
              content: [
                {closed: true, type: Integer, content: "2"},
              ]
            }
          ]
        }
      ]]
    end

    it "recognizes lists with symbols at the end" do
      expect(parser.call("(def lol bbq)")).to eq ["", [
        {
          closed: true,
          type: list_type,
          content: [
            {type: sym_type, content: "def", closed: true},
            {type: sym_type, content: "lol", closed: true},
            {type: sym_type, content: "bbq", closed: true},
          ]
        }
      ]]
    end
  end
end
