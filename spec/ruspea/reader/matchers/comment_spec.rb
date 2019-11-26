module Ruspea
  RSpec.describe Reader::Matchers::Comment do
    include Forms

    subject(:reader) { Reader.new }
    let(:pos) { Position }

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
      expect(result[2]).to eq Position.new(1, 2)
    end
  end
end
