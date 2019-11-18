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

    it "recognizes nested arrays" do
      result = reader.next("[[1 2] 3 [4 [5]]]")
      form = result.first

      expect(form).to eq Array.new([
        Array.new([
            Integer.new(1, pos.new(3, 1)),
            Integer.new(2, pos.new(5, 1))
          ], pos.new(2, 1)
        ),
        Integer.new(3, pos.new(8, 1)),
        Array.new([
          Integer.new(4, pos.new(11, 1)),
          Array.new([
            Integer.new(5, pos.new(14, 1))
          ], pos.new(13, 1))
        ], pos.new(10, 1))
      ])
    end

    it "returns the remaining code and new position" do
      result = reader.next("[1 2 3] [omg lol bbq]")

      expect(result[1]).to eq " [omg lol bbq]"
      expect(result[2]).to eq Ruspea::Interpreter::Position.new(8, 1)
    end
  end
end
