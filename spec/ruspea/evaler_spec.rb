module Ruspea
  RSpec.describe Evaler do
    let(:lisp) { Core::Scope.new.register_public Core::Lisp.new }
    let(:ctx) { Core::Context.new lisp }
    subject(:evaler) { described_class.new }

    describe "#eval", "List" do
      context "primitive functions" do
        describe "cond" do
          it "returns Nil if no arguments are given" do
            cond_nil = Core::List.create("cond")

            expect(evaler.eval(cond_nil, ctx)).to eq Core::Nill.instance
          end

          context "When finds a list where first element evals to true" do
            it "returns value after evaluating whole list" do
              cond_two = Core::List.create(
                "cond",
                Core::List.create(
                  Core::List.create("eq", 1, 2),
                  1
                ),
                Core::List.create(
                  Core::List.create("eq", Core::Symbol.new("a"), Core::Symbol.new("a")),
                  2
                )
              )

              cond_a = Core::List.create(
                "cond",
                Core::List.create(
                  Core::List.create("eq", 1, 2),
                  1
                ),
                Core::List.create(
                  Core::List.create("eq", Core::Symbol.new("a"), Core::Symbol.new("a")),
                  2, 3, 5, Core::List.create("quote", Core::Symbol.new("a"))
                )
              )

              clisp_consistency_three = Core::List.create(
                "cond",
                Core::List.create(
                  Core::List.create("eq", 1, 2),
                  1
                ),
                Core::List.create(3)
              )

              expect(evaler.eval(cond_two, ctx)).to eq 2
              expect(evaler.eval(cond_a, ctx)).to eq Core::Symbol.new("a")
              expect(evaler.eval(clisp_consistency_three, ctx)).to eq 3
            end
          end


          it "raises if a non-list 'clause' is evaluated" do
            non_list_clause = Core::List.create(
              "cond",
              Core::List.create(
                Core::List.create("eq", 1, 2),
                1
              ),
              2
            )

            expect { evaler.eval(non_list_clause, ctx) }.to raise_error Error::Execution
          end
        end

      end
    end
  end
end
