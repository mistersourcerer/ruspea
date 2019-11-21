module Ruspea::Interpreter::Forms
  RSpec.describe Ruspea::Interpreter::Matchers::Numeric do
    subject(:reader) { Ruspea::Interpreter::Reader.new }

    it "recognizes integers" do
      tuple = reader.next("1")
      form = tuple.first
      expect(form).to eq Integer.new(1)

      tuple = reader.next("420")
      form = tuple.first
      expect(form).to eq Integer.new(420)

      tuple = reader.next("-1")
      form = tuple.first
      expect(form).to eq Integer.new(-1)

      tuple = reader.next("-420")
      form = tuple.first
      expect(form).to eq Integer.new(-420)
    end

    it "recognizes floats" do
      tuple = reader.next("1.1")
      form = tuple.first
      expect(form).to eq Float.new(1.1)

      tuple = reader.next("420.1")
      form = tuple.first
      expect(form).to eq Float.new(420.1)

      tuple = reader.next("-1.1")
      form = tuple.first
      expect(form).to eq Float.new(-1.1)

      tuple = reader.next("-420.1")
      form = tuple.first
      expect(form).to eq Float.new(-420.1)
    end

    it "returns the remaining code and the new position" do
      result = reader.next("42 13")

      expect(result[1]).to eq " 13"
      expect(result[2]).to eq Ruspea::Interpreter::Position.new(3, 1)
    end
  end
end
