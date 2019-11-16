module Ruspea::Interpreter
  RSpec.describe String, "(Reader)" do
    subject(:reader) { Ruspea::Interpreter::Reader.new }

    it "recognizes strings" do
      tuple = reader.next("\"omg lol bbq\"")
      form = tuple.first

      expect(form).to eq Forms::String.new("omg lol bbq")
    end

    it "returns correct remaining code and new position" do
      result = reader.next("\"omg\" \"lol\"")

      expect(result[1]).to eq " \"lol\""
      expect(result[2]).to eq Position.new(5, 1)
    end
  end
end
