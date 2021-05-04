module Ruspea
  RSpec.describe do
    subject(:evaler) { Evaler.new }

    describe "#eval", "List" do
      describe "quote" do
        context "primitive functions" do
          it "returns the first argument" do
            quote_symbol = DS::List.create(:quote, :a)

            expect(evaler.eval(quote_symbol)).to eq :a
          end

          it "works when argument is a list" do
            quote_list = DS::List.create(:quote, DS::List.create(:a, :b))

            expect(evaler.eval(quote_list)).to eq DS::List.create(:a, :b)
          end

          it "raises if more than one argument is passed" do
            invalid_quote = DS::List.create(:quote, :a, :b)
            expect { evaler.eval(invalid_quote) }.to raise_error Error::Syntax
          end
        end

      end
    end
  end
end
