module Ruspea
  RSpec.describe Lisp::Lambda do
    include Core::Casting

    let(:env) { {} }
    subject(:lbd) { described_class.new }

    describe ".call" do
      it "raises if parameter is not a list" do
        expect { lbd.call(1, env) }.to raise_error(
          Error::Execution,
          /Argument should be a list with one element, received 1 instead/
        )
      end

      it "raises if no arguments list is passed" do
        expect { lbd.call(List(), env) }.to raise_error(
          Error::Execution,
          /A lambda needs the parameters list/
        )

        expect { lbd.call(List(1), env) }.to raise_error(
          Error::Execution,
          /A lambda needs the parameters list/
        )
      end

      it "raises if non symbols are passed in the args list" do
        expect { lbd.call(List(List(Symbol("a"), 1)), env) }.to raise_error(
          Error::Execution,
          /The element 1 should be a Symbol/
        )
      end

      it "returns a callable" do
        expect(lbd.call(List(List()), env).respond_to?(:call)).to eq true
      end

      it "the callable built has the right arity" do
        expect(lbd.call(List(List()), env).arity).to eq 0
        expect(lbd.call(List(List(Symbol("a"))), env).arity).to eq 1
      end
    end
  end
end
