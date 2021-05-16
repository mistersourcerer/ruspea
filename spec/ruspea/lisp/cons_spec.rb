module Ruspea
  RSpec.describe Lisp::Cons do
    include Core::Casting

    let(:ctx) { {} }
    subject(:cons) { described_class.new }

    describe "#call" do
      it "raises if parameter is not a list" do
        expect { cons.call(1, ctx) }.to raise_error(
          Error::Execution,
          /Argument should be a list, received 1 instead/
        )
      end

      it "raises if second parameter is not a list" do
        expect { cons.call(List(1, 2), ctx) }.to raise_error(
          Error::Execution,
          /Argument should be a list, received 2 instead/
        )
      end

      it "raises if wrong arity is used" do
        expect { cons.call(List(1), ctx) }.to raise_error(
          Error::Execution,
          /Wrong number of arguments: given 1, expected 2/
        )

        expect { cons.call(List(1, List(1), 1), ctx) }.to raise_error(
          Error::Execution,
          /Wrong number of arguments: given 3, expected 2/
        )
      end

      it "prepends an element to a list" do
        expect(cons.call(List(1, List(2, 3)), ctx)).to eq List(1, 2, 3)
        expect(cons.call(List(List(1, 2), List(3, 4)), ctx)).to eq List(List(1, 2), 3, 4)
      end
    end
  end
end
