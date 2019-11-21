module Ruspea::Interpreter::Forms
  RSpec.describe Ruspea::Interpreter::Matchers::Separator do
    subject(:reader) { Ruspea::Interpreter::Reader.new }

    it "recognizes space separators" do
      result = reader.next(" ")
      form = result.first
      expect(form).to eq Separator.new(" ")

      result = reader.next("   ")
      form = result.first
      expect(form).to eq Separator.new("   ")
    end

    it "recognizes comma separators" do
      result = reader.next(",,,")
      form = result.first
      expect(form).to eq Separator.new(",,,")
    end

    it "doesn't freak about tabs" do
      result = reader.next("\t")
      form = result.first
      expect(form).to eq Separator.new("\t")
    end

    it "returns the remaining code and new position" do
      result = reader.next(",  , \"omg\"")

      expect(result[1]).to eq "\"omg\""
      expect(result[2]).to eq Ruspea::Interpreter::Position.new(6, 1)
    end
  end
end
