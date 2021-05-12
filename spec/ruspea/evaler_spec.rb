module Ruspea
  RSpec.describe Evaler do
    def list(*args)
      Core::List.create(*args)
    end

    def sym(label)
      Core::Symbol.new(label)
    end

    let(:lisp) { Core::Scope.new.register_public Core::Lisp.new }
    let(:ctx) { Core::Context.new lisp }
    subject(:evaler) { described_class.new }

    describe "#eval" do
      it "raises if a unknown expression is evaluated" do
        expect { evaler.eval(:a) }.to raise_error Error::Execution
      end

      context "Lists" do
        it "evaluates lists as function calls (uses context for lookup)" do
          expect(evaler.eval(list("quote", sym("a")), ctx)).to eq sym("a")
        end

        it "raises if a function doesn't exists" do
          expect { evaler.eval(list("quote", 1)) }.to raise_error Error::Execution
        end

        it "passes the current context if scoped function has #arity == 2" do
          passed_ctx = nil
          ctx["weird"] = ->(_, current_ctx) { passed_ctx = current_ctx }
          evaler.eval(list("weird"), ctx)

          expect(passed_ctx).to be ctx
        end
      end

      context "Primitives" do
        it "evaluates a number to itself" do
          expect(evaler.eval(1)).to eq 1
          expect(evaler.eval(4.20)).to eq 4.20
        end

        it "evaluates a string to itself" do
          expect(evaler.eval("bbq")).to eq "bbq"
        end

        it "evaluates boolean to themselves" do
          expect(evaler.eval(true)).to eq true
          expect(evaler.eval(false)).to eq false
        end

        it "looks up symbol binding in the context" do
          scope = Core::Scope.new.tap { |s| s["a"] = "b" }
          ctx = Core::Context.new scope

          expect(evaler.eval(sym("a"), ctx)).to eq "b"
        end
      end
    end

    describe "#value_of" do
      it "evaluates all elements on a list, returns the last elem value" do
        ctx["lol"] = "bbq"

        expect(evaler.value_of(list(1, 2, sym("lol")), ctx)).to eq "bbq"
      end
    end
  end
end
