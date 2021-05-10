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

      describe "cond" do
        it "returns Nil if no arguments are given" do
          expect(lisp.cond list).to eq Core::Nill.instance
        end

        it "raises if no evaluator block is passed" do
          expect { lisp.cond list(list) }.to raise_error Error::Execution
        end

        context "When it finds a list where first element evals to true" do
          it "returns value after evaluating whole list" do
            cond_returning_primitive = list(
              list(list("eq", 1, 2), 1),
              list(list("eq", sym("a"), sym("a")), 2)
            )

            # Ensures that doesn't matter that we have
            # a bunch of stuff after the first "eq" condition,
            # everything is evaled and the last value returned.
            cond_much_stuff = list(
              list(list("eq", 1, 2), 1),
              list(list("eq", sym("a"), sym("a")), 2, 3, 5, list("quote", sym("a")))
            )

            clisp_consistency = list(
              list(list("eq", 1, 2), 1),
              list(3)
            )

            expect(lisp.cond(cond_returning_primitive, &evaler_blk)).to eq 2
            expect(lisp.cond(cond_much_stuff, &evaler_blk)).to eq sym("a")
            expect(lisp.cond(clisp_consistency, &evaler_blk)).to eq 3
          end
        end


        it "raises if a non-list 'clause' is evaluated" do
          non_list_clause = list(
            list(list("eq", 1, 2), 1),
            2
          )

          expect { lisp.cond(non_list_clause, &evaler_blk) }
            .to raise_error Error::Execution
        end
      end

      describe "#lambda" do
        it "raises if any non-symbol is in the list param" do
          expect { lisp.lambda(list(sym("a"), 1)) }.to raise_error Error::Execution
        end

        it "raises if no evaluation block is given" do
          expect { lisp.lambda(list(sym("a"), sym("b"))) }.to raise_error Error::Execution
        end

        context "Constructed function" do
          subject(:fun) {
            lisp.lambda(
              list(sym("a"), sym("b")), list("-", sym("a"), sym("b")),
              &evaler_blk
            )
          }

          it "returns a callable object with correct arity" do
            expect(fun.arity).to eq 2
          end

          it "raises if called with wrong arity" do
            pending
            expect { fun.call }.to raise_error Error::Execution
          end

          it "binds the parameters correctly" do
            pending
            expect(fun.call 5, 4).to eq 1
            expect(fun.call 4, 5).to eq -1
          end
        end
      end

    end
  end
end
