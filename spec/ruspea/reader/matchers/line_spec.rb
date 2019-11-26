module Ruspea
  include Forms

  RSpec.describe Reader::Matchers::Line do
    subject(:reader) { Reader.new }
    let(:pos) { Position }

    it "recognizes new lines" do
      result = reader.next("\n\n\n omg lol\n")
      form = result.first

      expect(form).to eq (Line.new(3, pos.new(1, 1)))
      expect(result[2]).to eq Position.new(1, 4)
    end

    it "returns the remaining code and new position" do
      result = reader.next("\n omg lol\n")

      expect(result[1]).to eq " omg lol\n"
      expect(result[2]).to eq Position.new(1, 2)
    end
  end
end
