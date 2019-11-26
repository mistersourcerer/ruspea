module Ruspea
  include Forms

  RSpec.describe Reader::Matchers::String do
    subject(:reader) { Reader.new }

    it "recognizes strings" do
      tuple = reader.next("\"omg lol bbq\"")
      form = tuple.first

      expect(form).to eq String.new("omg lol bbq")
    end

    it "returns the remaining code and new position" do
      result = reader.next("\"omg\" \"lol\"")

      expect(result[1]).to eq " \"lol\""
      expect(result[2]).to eq Position.new(6, 1)
    end
  end
end
