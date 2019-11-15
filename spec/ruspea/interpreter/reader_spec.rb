module Ruspea::Interpreter
  RSpec.describe Reader do
    subject(:reader) { described_class.new }

    context "numbers" do
      it "recognizes integers" do
        tuple = reader.next("1")
        form = tuple.first
        expect(form).to eq Forms::Integer.new(1, Position.new(0, 1))

        tuple = reader.next("420")
        form = tuple.first
        expect(form).to eq Forms::Integer.new(420, Position.new(0, 1))

        tuple = reader.next("-1")
        form = tuple.first
        expect(form).to eq Forms::Integer.new(-1, Position.new(0, 1))

        tuple = reader.next("-420")
        form = tuple.first
        expect(form).to eq Forms::Integer.new(-420, Position.new(0, 1))
      end

      it "recognizes floats" do
        tuple = reader.next("1.1")
        form = tuple.first
        expect(form).to eq Forms::Float.new(1.1, Position.new(0, 1))

        tuple = reader.next("420.1")
        form = tuple.first
        expect(form).to eq Forms::Float.new(420.1, Position.new(0, 1))

        tuple = reader.next("-1.1")
        form = tuple.first
        expect(form).to eq Forms::Float.new(-1.1, Position.new(0, 1))

        tuple = reader.next("-420.1")
        form = tuple.first
        expect(form).to eq Forms::Float.new(-420.1, Position.new(0, 1))
      end
    end
  end
end
