module Ruspea
  include Forms

  RSpec.describe Reader::Matchers::Quote do
    subject(:reader) { Reader.new }
    let(:pos) { Position }
    let(:list) { Runtime::List }

    it "recognizes quotings" do
      result = reader.next("'a")
      form = result.first
      expect(form).to eq (List.new(list.create(
          Symbol.new("quote", pos.new(0, 0)),
          Symbol.new("a", pos.new(2, 1))
        ), pos.new(1, 1))
      )

      result = reader.next("'(1 2 3)")
      form = result.first
      expect(form).to eq (List.new(list.create(
          Symbol.new("quote", pos.new(0, 0)),
          List.new(list.create(
            Integer.new(1, pos.new(3, 1)),
            Integer.new(2, pos.new(5, 1)),
            Integer.new(3, pos.new(7, 1)),
          ), pos.new(2, 1))
        ), pos.new(1, 1))
      )

      result = reader.next("'()")
      form = result.first
      expect(form).to eq (
        List.new(
          list.create(
            Symbol.new("quote", pos.new(0, 0)),
            List.new(
              Runtime::Nill.instance, pos.new(1, 1)
            )
          )
        )
      )
    end

    it "recongizes nested quotings" do
      result = reader.next("'(1 'two 3 ':four)")
      form = result.first

      expect(form).to eq (List.new(list.create(
          Symbol.new("quote", pos.new(0, 0)),
          List.new(list.create(
            Integer.new(1, pos.new(3, 1)),
            List.new(list.create(
              Symbol.new("quote", pos.new(0, 0)),
              Symbol.new("two", pos.new(6, 1))
            ), pos.new(5, 1)),
            Integer.new(3, pos.new(10, 1)),
            List.new(list.create(
              Symbol.new("quote", pos.new(0, 0)),
              Keyword.new("four", pos.new(13, 1))
            ), pos.new(12, 1)),
          ), pos.new(2, 1))
        ), pos.new(1, 1))
      )
    end

    it "returns the remaining code and new position" do
      result = reader.next("'(1 2 3) (print \"lol\")")

      expect(result[1]).to eq " (print \"lol\")"
      expect(result[2]).to eq Position.new(9, 1)
    end
  end
end
