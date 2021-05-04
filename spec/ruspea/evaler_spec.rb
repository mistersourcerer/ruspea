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

          it "returns the first argument" do
            quote_symbol = DS::List.create("quote", :a)

            expect(evaler.eval(quote_symbol)).to eq :a
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

      end
    end
  end
end
