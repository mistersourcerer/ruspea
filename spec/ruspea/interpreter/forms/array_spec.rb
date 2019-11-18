module Ruspea::Interpreter::Forms
  RSpec.describe Array do
    subject(:reader) { Ruspea::Interpreter::Reader.new }
    let(:pos) { Ruspea::Interpreter::Position }

    it "recognizes arrays" do
      result = reader.next("[13 4.2 :lol bbq]")
      form = result.first

      expect(form).to eq Array.new([
        Integer.new("13", pos.new(2, 1)),
        Float.new("4.2", pos.new(5, 1)),
        Keyword.new("lol", pos.new(9, 1)),
        Symbol.new("bbq", pos.new(14, 1)),
      ])
    end

    it "returns the remaining code and new position" do
      result = reader.next("[1 2 3] [omg lol bbq]")

      expect(result[1]).to eq " [omg lol bbq]"
      expect(result[2]).to eq Ruspea::Interpreter::Position.new(8, 1)
    end
  end
end
