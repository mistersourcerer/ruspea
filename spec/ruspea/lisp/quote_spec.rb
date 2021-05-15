module Ruspea
  RSpec.describe Lisp::Quote do
    include Core::Casting

    let(:ctx) { {} }
    subject(:quote) { described_class.new }

    describe "#call" do
      it "returns the expr without evaluating it" do
        expect(quote.call(List(List(1, 2, 3)), ctx)).to eq List(1, 2, 3)
        expect(quote.call(List(Symbol("a")), ctx)).to eq Symbol("a")
        expect(quote.call(List("lol"), ctx)).to eq "lol"
      end

      it "raises if parameter is not a list" do
        expect { quote.call(1, ctx) }.to raise_error(
          Error::Execution,
          /Argument should be a list with one element, received 1 instead/
        )
      end

      it "raises if wrong arity is used" do
        expect { quote.call(List(), ctx) }.to raise_error(
          Error::Execution,
          /Wrong number of arguments: given 0, expected 1/
        )

        expect { quote.call(List(1, 2), ctx) }.to raise_error(
          Error::Execution,
          /Wrong number of arguments: given 2, expected 1/
        )
      end
    end
  end
end
