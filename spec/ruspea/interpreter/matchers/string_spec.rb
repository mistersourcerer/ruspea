module Ruspea::Interpreter::Forms
  RSpec.describe Ruspea::Interpreter::Matchers::String do
    subject(:reader) { Ruspea::Interpreter::Reader.new }

    it "recognizes strings" do
      tuple = reader.next("\"omg lol bbq\"")
      form = tuple.first

      expect(form).to eq String.new("omg lol bbq")
    end

    it "returns the remaining code and new position" do
      result = reader.next("\"omg\" \"lol\"")

      expect(result[1]).to eq " \"lol\""
      expect(result[2]).to eq Ruspea::Interpreter::Position.new(6, 1)
    end
  end
end
