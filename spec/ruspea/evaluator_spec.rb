module Ruspea
  RSpec.describe Evaluator do
    subject(:evaluator) { described_class.new }

    describe "#eval" do
      context "Primitives" do
        it "evaluates a number to itself" do
          expect(evaluator.eval(1)).to eq 1
          expect(evaluator.eval(-1)).to eq -1
          expect(evaluator.eval(4.20)).to eq 4.20
        end

        it "evaluates a string to itself" do
          expect(evaluator.eval("lol")).to eq "lol"
        end
      end

      context "Symbol" do
        include Core::Casting

        let(:env) { Core::Environment.new }

        before do
          env["lol"] = 420
        end

        it "lookup the symbol in the environment" do
          expect(evaluator.eval(Symbol("lol"), env)).to eq 420
        end

        it "raises if symbol cannot be found in the environment" do
          expect { evaluator.eval(Symbol("bbq"), env) }.to raise_error(
            Error::Execution,
            /Unable to/
          )
        end
      end
    end
  end
end
