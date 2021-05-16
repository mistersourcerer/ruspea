module Ruspea
  RSpec.describe Lisp::Car do
    include Core::Casting

    let(:ctx) { {} }
    subject(:car) { described_class.new }

    describe "#call" do
      it "raises if parameter is not a list" do
        expect { car.call(1, ctx) }.to raise_error(
          Error::Execution,
          /Argument should be a list, received 1 instead/
        )
      end

      it "raises if wrong arity is used" do
        expect { car.call(List(), ctx) }.to raise_error(
          Error::Execution,
          /Argument should be a list/
        )

        expect { car.call(List(List(1), 1), ctx) }.to raise_error(
          Error::Execution,
          /Wrong number of arguments: given 2, expected 1/
        )
      end

      it "returns the first element on a list" do
        expect(car.call(List(List(1, 2)), ctx)).to eq 1
      end

      it "returns nil if the list empty" do
        expect(car.call(List(List()), ctx)).to eq nil
      end
    end
  end
end
