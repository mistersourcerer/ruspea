module Ruspea::Forms
  RSpec.describe Ruspea::Interpreter::Matchers::Line do
    subject(:reader) { Ruspea::Interpreter::Reader.new }
    let(:pos) { Ruspea::Interpreter::Position }

    it "recognizes new lines" do
      result = reader.next("\n\n\n omg lol\n")
      form = result.first

      expect(form).to eq (Line.new(3, pos.new(1, 1)))
      expect(result[2]).to eq Ruspea::Interpreter::Position.new(1, 4)
    end

    it "returns the remaining code and new position" do
      result = reader.next("\n omg lol\n")

      expect(result[1]).to eq " omg lol\n"
      expect(result[2]).to eq Ruspea::Interpreter::Position.new(1, 2)
    end
  end
end
