module Ruspea
  RSpec.describe Core::Lisp do
    def list(*args)
      Core::List.create(*args)
    end

    def sym(label)
      Core::Symbol.new(label)
    end

    subject(:lisp) { described_class.new }

    describe "#quote" do
      it "raises if more than one argument is passed" do
        expect { lisp.quote list(:a, :b) }.to raise_error Error::Execution
      end

      it "returns argument without evaluating it" do
        expect(lisp.quote list(sym("a"))).to eq sym("a")
        expect(lisp.quote list(1)).to eq 1
        expect(lisp.quote list(list(:a, :b))).to eq list(:a, :b)
      end
    end

    describe "atom" do
      it "raises if more than one argument is passed" do
        expect { lisp.atom list(:a, :b) }.to raise_error Error::Execution
      end

      it "returns true for symbols" do
        expect(lisp.atom list(sym("omg"))).to eq true
      end

      it "returns true for string" do
        expect(lisp.atom list("lol")).to eq true
      end

      it "returns true for numbers" do
        expect(lisp.atom list(1)).to eq true
        expect(lisp.atom list(4.20)).to eq true
        expect(lisp.atom list(-4.20)).to eq true
      end

      it "returns true for empty lists" do
        expect(lisp.atom list(list)).to eq true
        expect(lisp.atom list(Core::Nill.instance)).to eq true
      end

      it "returns true for bools" do
        expect(lisp.atom list(true)).to eq true
        expect(lisp.atom list(false)).to eq true
      end

      it "returns false for non-empty lists" do
        expect(lisp.atom list(list(1, 2, 3))).to eq false
      end
    end

    describe "eq" do
      it "raises if arguments.count is != 2" do
        expect { lisp.eq list("a", "b", "c") }.to raise_error Error::Execution
        expect { lisp.eq list("a") }.to raise_error Error::Execution
      end

      it "compares symbols by it's labels" do
        expect(lisp.eq list(sym("a"), sym("a"))).to eq true
        expect(lisp.eq list(sym("a"), sym("b"))).to eq false
      end

      it "compares numbers" do
        expect(lisp.eq list(1, 1)).to eq true
        expect(lisp.eq list(-1, -1)).to eq true
        expect(lisp.eq list(4.20, 4.20)).to eq true
        expect(lisp.eq list(1, 1.0)).to eq true
        expect(lisp.eq list(1, 2)).to eq false
      end
    end

    context "When args need evaluation" do
      let(:ctx) { Core::Context.new Core::Scope.new.register_public(lisp) }
      let(:evaler) { Evaler.new }
      let(:evaler_blk) { ->(arg) { evaler.eval(arg, ctx) } }

      describe "car" do
        it "raises if more than one arg is passed" do
          expect { lisp.car list("a", "b") }.to raise_error Error::Execution
        end

        it "raises if arg is not a list" do
          expect { lisp.car list(1) }.to raise_error Error::Execution
        end

        it "raises if no evaluator block is passed" do
          expect { lisp.car list(list(1, 2)) }.to raise_error Error::Execution
        end

        it "returns the first element of the list AFTER EVALUATING IT" do
          quote_expr = list("quote", list(1, 2))
          result = lisp.car(list(quote_expr), &evaler_blk)

          expect(result).to eq 1
        end
      end

      describe "cdr" do
        it "raises if more than one arg is passed" do
          expect { lisp.cdr list("a", "b") }.to raise_error Error::Execution
        end

        it "raises if arg is not a list" do
          expect { lisp.cdr list(1) }.to raise_error Error::Execution
        end

        it "raises if no evaluator block is passed" do
          expect { lisp.cdr list(list(1, 2)) }.to raise_error Error::Execution
        end

        it "returns the rest (all but first elment) of the list" do
          quote_expr = list("quote", list(1, 2, 3))
          result = lisp.cdr(list(quote_expr), &evaler_blk)

          expect(result).to eq list(2, 3)
        end
      end

      describe "cons" do
        it "raises if arguments.count is != 2" do
          expect { lisp.cons list("a", "b", "c") }.to raise_error Error::Execution
          expect { lisp.cons list("a") }.to raise_error Error::Execution
        end

        it "raises if second arg is not a list" do
          expect { lisp.cons list(1, "not a list") }.to raise_error Error::Execution
        end

        it "raises if no evaluator block is passed" do
          expect { lisp.cons list(list(1, list)) }.to raise_error Error::Execution
        end

        it "returns a list where head is first arg and tail second arg" do
          cons = list(1, list("quote", list(2, 3)))
          cons_list = list(list("quote", list(1, 2)), list("quote", list(3, 4)))

          expect(lisp.cons(cons, &evaler_blk)).to eq list(1, 2, 3)
          expect(lisp.cons(cons_list, &evaler_blk)).to eq list(list(1, 2), 3, 4)
        end
      end
    end
  end
end
