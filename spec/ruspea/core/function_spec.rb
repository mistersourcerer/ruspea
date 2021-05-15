module Ruspea
  RSpec.describe Core::Function do
    include Core::Casting

    let(:params) { List("a", "b") }
    let(:body) { List(1) }
    let(:ctx) { Core::Context.new }

    subject(:fun) { described_class.new(params, body, ctx) }

    describe "#arity" do
      it "knows it's arity given the params list" do
        expect(fun.arity).to eq 2
      end
    end

    describe "#call" do
      it "raises if wrong number of args is passed" do
        expect { fun.call(List()) }.to raise_error(
          Error::Execution,
          /Wrong number of args: 0 passed, 2 expected/
        )

        expect { fun.call(List(1)) }.to raise_error(
          Error::Execution,
          /Wrong number of args: 1 passed, 2 expected/
        )

        expect { fun.call(List(1, 2, 3)) }.to raise_error(
          Error::Execution,
          /Wrong number of args: 3 passed, 2 expected/
        )
      end

      it "uses context to evaluate the body" do
        expect(fun.call(List(4, 20))).to eq 1
      end

      it "binds the arguments for passed to the function" do
        body = List(Symbol("a"))
        f = described_class.new(params, body, ctx)
        expect(f.call(List(4, 20))).to eq 4

        body = List(Symbol("b"))
        f = described_class.new(params, body, ctx)
        expect(f.call(List(4, 20))).to eq 20
      end
    end
  end
end
