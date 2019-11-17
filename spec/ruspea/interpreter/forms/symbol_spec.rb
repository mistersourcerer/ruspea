module Ruspea::Interpreter::Forms
  RSpec.describe Symbol do
    subject(:reader) { Ruspea::Interpreter::Reader.new }

    it "recognizes symbols" do
      tuple = reader.next("lol bbq")
      form = tuple.first

      expect(form).to eq Symbol.new("lol")
    end

    it "returns the remaining code and new position" do
      result = reader.next("omg lol")

      expect(result[1]).to eq " lol"
      expect(result[2]).to eq Ruspea::Interpreter::Position.new(4, 1)
    end
  end
end
