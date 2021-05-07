module Ruspea
  RSpec.describe do
    subject(:evaler) { Evaler.new }

    describe "#eval", "List" do
      context "primitive functions" do
        describe "quote" do
          it "raises if more than one argument is passed" do
            invalid_quote = DS::List.create("quote", :a, :b)

            expect { evaler.eval(invalid_quote) }.to raise_error Error::Syntax
          end

          it "quotes a symbol instance" do
            symbol_a = DS::List.create("quote", Core::Symbol.new("a"))

            expect(evaler.eval(symbol_a).label).to eq "a"
          end

          it "returns the first argument" do
            quote_symbol = DS::List.create("quote", Core::Symbol.new("a"))

            expect(evaler.eval(quote_symbol)).to eq Core::Symbol.new("a")
          end

          it "works when argument is a list" do
            quote_list = DS::List.create("quote", DS::List.create(:a, :b))

            expect(evaler.eval(quote_list)).to eq DS::List.create(:a, :b)
          end
        end

        describe "atom" do
          it "raises if more than one argument is passed" do
            invalid_atom = DS::List.create("atom", "a", "b")

            expect { evaler.eval(invalid_atom) }.to raise_error Error::Syntax
          end

          it "returns true for symbols" do
            sym_atom = DS::List.create("atom", Core::Symbol.new("omg"))

            expect(evaler.eval(sym_atom)).to eq true
          end

          it "returns true for string" do
            str_atom = DS::List.create("atom", "omg")

            expect(evaler.eval(str_atom)).to eq true
          end

          it "returns true for numbers" do
            int_atom = DS::List.create("atom", 1)
            float_atom = DS::List.create("atom", 4.20)
            negative_atom = DS::List.create("atom", -4.20)

            expect(evaler.eval(int_atom)).to eq true
            expect(evaler.eval(float_atom)).to eq true
            expect(evaler.eval(negative_atom)).to eq true
          end

          it "returns true for empty lists" do
            empty_list = DS::List.create("atom", DS::List.create)
            nil_list = DS::List.create("atom", DS::Nill.instance)

            expect(evaler.eval(empty_list)).to eq true
            expect(evaler.eval(nil_list)).to eq true
          end

          it "returns true for bools" do
            true_bool = DS::List.create("atom", true)
            false_bool = DS::List.create("atom", false)

            expect(evaler.eval(true_bool)).to eq true
            expect(evaler.eval(false_bool)).to eq true
          end

          it "returns false for non-empty lists" do
            list = DS::List.create("atom", DS::List.create("quote", DS::List.create(1, 2, 3)))
            atom = DS::List.create("atom", DS::List.create("atom", "a"))

            expect(evaler.eval(list)).to eq false
          end
        end

        describe "eq" do
          it "raises if more than two arguments are passed" do
            invalid_eq = DS::List.create("eq", "a", "b", "c")

            expect { evaler.eval(invalid_eq) }.to raise_error Error::Syntax
          end

          it "raises if only one arg is passed" do
            invalid_eq = DS::List.create("eq", "a")

            expect { evaler.eval(invalid_eq) }.to raise_error Error::Syntax
          end

          it "returns true when symbols have the same label" do
            eq_sym = DS::List.create("eq", Core::Symbol.new("a"), Core::Symbol.new("a"))

            expect(evaler.eval(eq_sym)).to eq true
          end

          it "returns false when symbols have different label" do
            eq_diff_sym = DS::List.create("eq", Core::Symbol.new("a"), Core::Symbol.new("b"))

            expect(evaler.eval(eq_diff_sym)).to eq false
          end

          it "returns true when numbers are the same" do
            eq_int = DS::List.create("eq", 1, 1)
            eq_float = DS::List.create("eq", 4.20, 4.20)
            eq_value = DS::List.create("eq", 1, 1.0)

            expect(evaler.eval(eq_int)).to eq true
            expect(evaler.eval(eq_float)).to eq true
            expect(evaler.eval(eq_value)).to eq true
          end

          it "returns false for different numbers" do
            eq_diff_int = DS::List.create("eq", 1, 2)

            expect(evaler.eval(eq_diff_int)).to eq false
          end
        end

        describe "car" do
          it "raises if more than one arg is passed" do
            car_too_many_args = DS::List.create("car", 1, 2)

            expect { evaler.eval(car_too_many_args) }.to raise_error Error::Syntax
          end

          it "raises if arg is not a list" do
            car_without_list = DS::List.create("car", 1)

            expect { evaler.eval(car_without_list) }.to raise_error Error::Execution
          end

          it "returns the first element of the list" do
            car = DS::List.create(
              "car",
              DS::List.create("quote", DS::List.create(1, 2))
            )

            expect(evaler.eval(car)).to eq 1
          end
        end

        describe "cdr" do
          it "raises if more than one arg is passed" do
            cdr_too_many_args = DS::List.create(Core::Symbol.new("cdr"), 1, 2)

            expect { evaler.eval(cdr_too_many_args) }.to raise_error Error::Syntax
          end

          it "raises if arg is not a list" do
            cdr_without_list = DS::List.create(Core::Symbol.new("cdr"), 1)

            expect { evaler.eval(cdr_without_list) }.to raise_error Error::Execution
          end

          it "returns the first element of the list" do
            cdr = DS::List.create(
              Core::Symbol.new("cdr"),
              DS::List.create("quote", DS::List.create(1, 2, 3))
            )

            expect(evaler.eval(cdr)).to eq DS::List.create(2, 3)
          end
        end

        describe "cons" do
          it "raises if only one arg is passed" do
            cons_not_enough = DS::List.create("cons", 1)

            expect { evaler.eval(cons_not_enough) }.to raise_error Error::Syntax
          end

          it "raises if more than two args are passed" do
            cons_too_many = DS::List.create("cons", 1, 2, 3)

            expect { evaler.eval(cons_too_many) }.to raise_error Error::Syntax
          end

          it "raises if second arg is not a list" do
            cons_without_list = DS::List.create("cons", 1, 1)

            expect { evaler.eval(cons_without_list) }.to raise_error Error::Execution
          end

          it "returns a list where head is first arg and tail second arg" do
            cons = DS::List.create(
              "cons", 1, DS::List.create("quote", DS::List.create(2, 3)))
            cons_list = DS::List.create(
              "cons",
              DS::List.create("quote", DS::List.create(1, 2)),
              DS::List.create("quote", DS::List.create(3, 4))
            )

            expect(evaler.eval(cons)).to eq DS::List.create(1, 2, 3)
            expect(evaler.eval(cons_list)).to eq DS::List.create(
              DS::List.create(1, 2), 3, 4
            )
          end
        end

        describe "cond" do
          it "returns Nil if no arguments are given" do
            cond_nil = DS::List.create("cond")

            expect(evaler.eval(cond_nil)).to eq DS::Nill.instance
          end

          context "When finds a list where first element evals to true" do
            it "returns value after evaluating whole list" do
              cond_two = DS::List.create(
                "cond",
                DS::List.create(
                  DS::List.create("eq", 1, 2),
                  1
                ),
                DS::List.create(
                  DS::List.create("eq", Core::Symbol.new("a"), Core::Symbol.new("a")),
                  2
                )
              )

              cond_a = DS::List.create(
                "cond",
                DS::List.create(
                  DS::List.create("eq", 1, 2),
                  1
                ),
                DS::List.create(
                  DS::List.create("eq", Core::Symbol.new("a"), Core::Symbol.new("a")),
                  2, 3, 5, DS::List.create("quote", Core::Symbol.new("a"))
                )
              )

              clisp_consistency_three = DS::List.create(
                "cond",
                DS::List.create(
                  DS::List.create("eq", 1, 2),
                  1
                ),
                DS::List.create(3)
              )

              expect(evaler.eval(cond_two)).to eq 2
              expect(evaler.eval(cond_a)).to eq Core::Symbol.new("a")
              expect(evaler.eval(clisp_consistency_three)).to eq 3
            end
          end


          it "raises if a non-list 'clause' is evaluated" do
            non_list_clause = DS::List.create(
              "cond",
              DS::List.create(
                DS::List.create("eq", 1, 2),
                1
              ),
              2
            )

            expect { evaler.eval(non_list_clause) }.to raise_error Error::Execution
          end
        end

      end
    end
  end
end
