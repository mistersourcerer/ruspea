module Ruspea
  RSpec.describe Lisp::Atom do
    include Core::Casting

    let(:ctx) { {} }
    subject(:atom) { described_class.new }

    describe "#call" do
      it "raises if parameter is not a list" do
        expect { atom.call(1, ctx) }.to raise_error(
          Error::Execution,
          /Argument should be a list, received 1 instead/
        )
      end

      it "raises if wrong arity is used" do
        expect { atom.call(List(), ctx) }.to raise_error(
          Error::Execution,
          /Wrong number of arguments: given 0, expected 1/
        )

        expect { atom.call(List(1, 2), ctx) }.to raise_error(
          Error::Execution,
          /Wrong number of arguments: given 2, expected 1/
        )
      end

      it "returns true for symbols" do
        expect(atom.call(List(Symbol("a")), ctx)).to eq true
      end

      it "returns true for empty lists" do
        expect(atom.call(List(List()), ctx)).to eq true
      end

      it "returns true for strings" do
        expect(atom.call(List("no dice"), ctx)).to eq true
      end

      it "returns true for numbers" do
        expect(atom.call(List(1), ctx)).to eq true
      end

      it "returns true for booleans" do
        expect(atom.call(List(true), ctx)).to eq true
        expect(atom.call(List(false), ctx)).to eq true
      end

      it "returns false for lists with elements" do
        expect(atom.call(List(List(1, 2)), ctx)).to eq false
      end
    end
  end
end
