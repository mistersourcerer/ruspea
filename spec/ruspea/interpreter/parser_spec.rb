module Ruspea::Interpreter
  RSpec.describe Parser do
    subject(:parser) { described_class.new }

    it "ignores spaces and commas" do
      expect(parser.call(", , ,")).to eq ["", []]
    end

    it "ignores blank lines" do
      expect(parser.call("\n\n")).to eq ["", []]
    end

    it "parses symbols" do
      expect(parser.call("lol")).to eq ["", [
        {type: Ruspea::Runtime::Sym, content: "lol", closed: true}
      ]]
    end

    it "parses arrays" do
      expect(parser.call('[1 "omg" lol]')).to eq ["", [
        {
          type: Array,
          closed: true,
          content:[
            {type: Integer, content: "1", closed: true},
            {type: String, content: "omg", closed: true},
            {type: Ruspea::Runtime::Sym, content: "lol", closed: true}
          ]
        }
      ]]
    end
  end
end
