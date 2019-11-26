module Ruspea
  include Forms

  RSpec.describe Reader::Matchers::Map do
    subject(:reader) { Reader.new }
    let(:pos) { Position }

    it "recognizes maps" do
      result = reader.next("{one: 1 two: 2.0 three: \"three\" four: :four :five 5}")
      form = result.first

      expect(form).to eq Map.new({
        Keyword.new("one", pos.new(2, 1)) => Integer.new("1", pos.new(7, 1)),
        Keyword.new("two", pos.new(9, 1)) => Float.new("2.0", pos.new(14, 1)),
        Keyword.new("three", pos.new(18, 1)) => String.new("three", pos.new(25, 1)),
        Keyword.new("four", pos.new(33, 1)) => Keyword.new("four", pos.new(39, 1)),
        Keyword.new("five", pos.new(45, 1)) => Integer.new("5", pos.new(51, 1)),
      })
    end

    it "raise specific error when wrong amount of stuff is given" do
      expect {
        reader.next("{one: 1 two:}")
      }.to raise_error(Reader::Matchers::Map::WrongFormat)
    end

    it "handle nested maps" do
      result = reader.next("{one: 1 two: {three: 3 four: {five: 5}}}")
      form = result.first

      expect(form).to eq Map.new({
        Keyword.new("one", pos.new(2, 1)) => Integer.new(1, pos.new(7, 1)),
        Keyword.new("two", pos.new(9, 1)) => Map.new({
          Keyword.new("three", pos.new(15, 1)) => Integer.new(3, pos.new(22, 1)),
          Keyword.new("four", pos.new(24, 1)) => Map.new({
            Keyword.new("five", pos.new(31, 1)) => Integer.new(5, pos.new(37, 1)),
          }, pos.new(30, 1)),
        }, pos.new(14, 1)),
      })
    end

    it "returns the remaining code and new position" do
      result = reader.next("{one: 1 two: 2} {three: 3}")

      expect(result[1]).to eq " {three: 3}"
      expect(result[2]).to eq Position.new(16, 1)
    end
  end
end
