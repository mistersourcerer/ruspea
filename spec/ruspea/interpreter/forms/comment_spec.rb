module Ruspea::Interpreter::Forms
  RSpec.describe Comment do
    subject(:reader) { Ruspea::Interpreter::Reader.new }
    let(:pos) { Ruspea::Interpreter::Position }

    it "recognizes comments" do
      result = reader.next(";omg lol; bbq")
      form = result.first
      expect(form).to eq (Comment.new("omg lol; bbq", pos.new(1, 1)))

      result = reader.next(";omg lol bbq\n\"such a comment\"")
      form = result.first
      expect(form).to eq (Comment.new("omg lol bbq", pos.new(1, 1)))
    end

    it "returns the remaining code and new position" do
      result = reader.next("; omg lol\n1")

      expect(result[1]).to eq "1"
      expect(result[2]).to eq Ruspea::Interpreter::Position.new(1, 2)
    end
  end
end
