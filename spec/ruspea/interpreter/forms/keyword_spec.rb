module Ruspea::Interpreter::Forms
  RSpec.describe Keyword do
    subject(:reader) { Ruspea::Interpreter::Reader.new }

    it "recognizes keywords" do
      result = reader.next(":lol bbq")
      form = result.first
      expect(form).to eq Keyword.new("lol")

      result = reader.next("lol: bbq")
      form = result.first
      expect(form).to eq Keyword.new("lol")

      expect(Keyword.new("lol")).to eq Keyword.new("lol")
    end

    it "returns the remaining code and new position" do
      result = reader.next("omg: lol:")

      expect(result[1]).to eq " lol:"
      expect(result[2]).to eq Ruspea::Interpreter::Position.new(5, 1)
    end
  end
end
