module Ruspea
  include Forms

  RSpec.describe Reader::Matchers::List do
    subject(:reader) { Reader.new }
    let(:pos) { Position }
    let(:builder) { Runtime::List }

    it "recognizes lists" do
      result = reader.next("(13 4.2 :omg lol: bbq \"lisp\" { one: 1} [1, 2 ])")
      form = result.first

      expect(form).to eq List.new(builder.create(
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

    it "recognizes nested lists" do
      result = reader.next("((1 2) 3 (4 (5)))")
      form = result.first

      expect(form).to eq List.new(builder.create(
        List.new(
          builder.create(
            Integer.new(1, pos.new(3, 1)),
            Integer.new(2, pos.new(5, 1))
          ), pos.new(2, 1)
        ),
        Integer.new(3, pos.new(8, 1)),
        List.new(builder.create(
          Integer.new(4, pos.new(11, 1)),
          List.new(builder.create(
            Integer.new(5, pos.new(14, 1))
          ), pos.new(13, 1))
        ), pos.new(10, 1))
      ))
    end

    it "recongizes empty lists" do
      result = reader.next("( )")
      form = result.first

      expect(form).to eq List.new(Runtime::Nil.instance, pos.new(1, 1))
    end

    it "returns the remaining code and new position" do
      result = reader.next("(1 2) (3 4)")

      expect(result[1]).to eq " (3 4)"
      expect(result[2]).to eq Position.new(6, 1)
    end
  end
end
