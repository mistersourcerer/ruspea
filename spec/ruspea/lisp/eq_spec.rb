module Ruspea
  RSpec.describe Lisp::Eq do
    include Core::Casting
    let(:ctx) { {} }
    subject(:eq_fun) { described_class.new } # to not override RSpec#eq

    describe "#call" do
      it "raises if parameter is not a list" do
        expect { eq_fun.call(1, ctx) }.to raise_error(
          Error::Execution,
          /Argument should be a list, received 1 instead/
        )
      end

      it "raises if wrong arity is used" do
        expect { eq_fun.call(List(), ctx) }.to raise_error(
          Error::Execution,
          /Wrong number of arguments: given 0, expected 2/
        )

        expect { eq_fun.call(List(1), ctx) }.to raise_error(
          Error::Execution,
          /Wrong number of arguments: given 1, expected 2/
        )

        expect { eq_fun.call(List(1, 1, 1), ctx) }.to raise_error(
          Error::Execution,
          /Wrong number of arguments: given 3, expected 2/
        )
      end

      it "compares numbers" do
        expect(eq_fun.call(List(1, 1), ctx)).to eq true
        expect(eq_fun.call(List(4.20, 4.20), ctx)).to eq true
        expect(eq_fun.call(List(1, 1.0), ctx)).to eq true
        expect(eq_fun.call(List(-1, -1.0), ctx)).to eq true
        expect(eq_fun.call(List(1, 2), ctx)).to eq false
      end

      it "compares strings" do
        # as per clisp, they are different
        expect(eq_fun.call(List("lol", "lol"), ctx)).to eq false
        expect(eq_fun.call(List("lol", "lola"), ctx)).to eq false
      end

      it "compares lists" do
        # as per clisp, they are different
        expect(eq_fun.call(List(List(1), List(1)), ctx)).to eq false
        expect(eq_fun.call(List(List(), List()), ctx)).to eq true
      end

      it "compares symbols" do
        expect(eq_fun.call(List(Symbol("lol"), Symbol("lol")), ctx)).to eq true
        expect(eq_fun.call(List(Symbol("lol"), Symbol("lola")), ctx)).to eq false
      end

      it "compares booleans" do
        expect(eq_fun.call(List(true, true), ctx)).to eq true
        expect(eq_fun.call(List(false, false), ctx)).to eq true
        expect(eq_fun.call(List(true, false), ctx)).to eq false
      end
    end
  end
end
