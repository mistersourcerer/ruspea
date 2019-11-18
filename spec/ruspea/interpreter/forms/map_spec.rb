module Ruspea::Interpreter::Forms
  RSpec.describe Map do
    subject(:reader) { Ruspea::Interpreter::Reader.new }
    let(:pos) { Ruspea::Interpreter::Position }

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

    it "returns the remaining code and new position" do
      result = reader.next("{one: 1 two: 2} {three: 3}")

      expect(result[1]).to eq " {three: 3}"
      expect(result[2]).to eq Ruspea::Interpreter::Position.new(16, 1)
    end
  end
end
