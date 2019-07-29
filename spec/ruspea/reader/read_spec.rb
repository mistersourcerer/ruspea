module Ruspea::Reader
  RSpec.describe Read do
    let(:builder) { Ruspea::Runtime::List }
    subject(:reader) { described_class.new }

    def sym(string)
      Ruspea::Runtime::Sym.new string
    end

    describe "#call" do
      context "lisping!" do
        context "delimiting" do
          it "knows how to read a list" do
            expect(reader.call("(one pretty list)")).to eq [
              builder.create(sym("one"), sym("pretty"), sym("list")),
            ]
          end

          it "recognizes a 'not closed' list" do
            expect(reader.call("(one pretty list")).to eq [
              {
                type: Ruspea::Runtime::List,
                closed: false,
                tokens: [
                  sym("one"), sym("pretty"), sym("list")
                ],
              }
            ]
          end

          it "recognizes nested lists" do
            expect(reader.call("(one (pretty list) here)")).to eq [
              builder.create(
                sym("one"),
                builder.create(sym("pretty"), sym("list")),
                sym("here"),
              )
            ]
          end
        end # delimiting

        context "multiple expressions" do
          it "creates one 'node' for each expression found" do
            expressions = reader.call("(one pretty list) (and another)")

            expect(expressions).to eq [
              builder.create(sym("one"), sym("pretty"), sym("list")),
              builder.create(sym("and"), sym("another")),
            ]
          end
        end # multiple expressions

        context "quoting" do
          it "reads quoting for lists" do
            expressions = reader.call("'(lol bbq)")

            expect(expressions).to eq [
              builder.create(
                sym("quote"),
                builder.create(sym("lol"), sym("bbq")),
              ),
            ]
          end

          it "reads quoting for symbols" do
            expressions = reader.call("'lol")

            expect(expressions).to eq [
              builder.create(sym("quote"), sym("lol")),
            ]
          end
        end # quoting
      end # lisping

      context "numbers" do
        it "recognizes int as first class citzens" do
          expressions = reader.call("1")

          expect(expressions).to eq [ 1 ]
        end

        it "recognizes floats" do
          expressions = reader.call("4.20")

          expect(expressions).to eq [ 4.20 ]
        end

        it "emulates ruby's _ to make numeric values readable" do
          expressions = reader.call("4_20 4.2_0")

          expect(expressions).to eq [ 420, 4.20 ]
        end

        it "recognizes negatives" do
          expressions = reader.call("-1 -4.20")

          expect(expressions).to eq [ -1, -4.20 ]
        end

        context "incomplete (possible) number" do
          it "recognizes an 'incomplete' number" do
            expect(reader.call("-")).to eq [ sym("-") ]
          end

          it "recognizes an 'incomplete' number amongst others" do
            expect(reader.call("420 - 42")).to eq [ 420, sym("-"), 42 ]
          end
        end

        context "invalid numbers" do
          it "raises for invalid numbers (too much .)" do
            expect {
              reader.call("4.2.0")
            }.to raise_error(
              Ruspea::Error::Syntax, "Invalid number: 4.2.(...)")
          end

          it "raises for invalid numbers (invalid chars)" do
            expect {
              reader.call("4*2.0")
            }.to raise_error(
              Ruspea::Error::Syntax, "Invalid number: 4*(...)")
          end
        end
      end# numbers

    end # call
  end
end
