module Ruspea
  RSpec.describe Evaluator do
    subject(:evaluator) { described_class.new }

    describe "#eval" do
      include Core::Casting

      let(:env) { Core::Environment.new }

      context "Primitives" do
        it "evaluates a number to itself" do
          expect(evaluator.eval(1)).to eq 1
          expect(evaluator.eval(-1)).to eq -1
          expect(evaluator.eval(4.20)).to eq 4.20
        end

        it "evaluates a string to itself" do
          expect(evaluator.eval("lol")).to eq "lol"
        end

        it "evaluates bools" do
          expect(evaluator.eval(true)).to eq true
          expect(evaluator.eval(false)).to eq false
        end
      end

      context "Symbol" do
        it "lookup the symbol in the environment" do
          env["lol"] = 420

          expect(evaluator.eval(Symbol("lol"), env)).to eq 420
        end

        it "raises if symbol cannot be found in the environment" do
          expect { evaluator.eval(Symbol("bbq"), env) }.to raise_error(
            Error::Execution,
            /Unable to resolve/
          )
        end
      end

      context "Lists" do
        it "handles lists as function invocations" do
          env["going_down"] = ->(_, _) { 42 }
          expr = List(Symbol("going_down"))

          expect(evaluator.eval(expr, env)).to eq 42
        end

        it "passed the args and the context to the callable" do
          passed_args = nil
          passed_ctx = nil
          env["going_down"] = ->(args, ctx) {
            passed_args = args
            passed_ctx = ctx
          }
          expr = List(Symbol("going_down"), 1, 2, 3)
          evaluator.eval(expr, env)

          expect(passed_args).to eq List(1, 2, 3)
          expect(passed_ctx.respond_to?(:eval)).to eq true
          expect(passed_ctx.respond_to?(:[])).to eq true
        end

        it "raise if first element is not bound" do
          expect { evaluator.eval(Symbol("bbq"), env) }.to raise_error(
            Error::Execution,
            /Unable to resolve/
          )
        end

        it "raises if first element doesn't evaluates to a callable" do
          env["not_going"] = 420
          expr = List(Symbol("not_going"))

          expect { evaluator.eval(expr, env) }.to raise_error(
            Error::Execution,
            /Unable to treat 420 as a callable thing/
          )
        end
      end
    end
  end
end
