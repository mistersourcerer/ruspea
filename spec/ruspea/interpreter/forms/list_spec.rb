module Ruspea::Interpreter::Forms
  RSpec.describe List do
    subject(:reader) { Ruspea::Interpreter::Reader.new }
    let(:pos) { Ruspea::Interpreter::Position }

    it "recognizes lists" do
      result = reader.next("(13 4.2 :omg lol: bbq \"lisp\" { one: 1} [1, 2 ])")
      form = result.first

      expect(form).to eq List.new(Ruspea::Runtime::List.create(
        Integer.new("13", pos.new(2, 1)),
        Float.new("4.2", pos.new(5, 1)),
        Keyword.new("omg", pos.new(9, 1)),
        Keyword.new("lol", pos.new(14, 1)),
        Symbol.new("bbq", pos.new(19, 1)),
        String.new("lisp", pos.new(23, 1)),
        Map.new({
          Keyword.new("one", pos.new(32, 1)) => Integer.new("1", pos.new(37, 1))
        }, pos.new(30, 1)),
        Array.new([
          Integer.new("1", pos.new(41, 1)),
          Integer.new("2", pos.new(44, 1)),
        ], pos.new(40, 1)),
      ))
    end

    it "returns the remaining code and new position" do
      result = reader.next("(1 2) (3 4)")

      expect(result[1]).to eq " (3 4)"
      expect(result[2]).to eq Ruspea::Interpreter::Position.new(6, 1)
    end
  end
end
