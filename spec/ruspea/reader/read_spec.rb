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
        end

        context "multiple expressions" do
          it "creates one 'node' for each expression found" do
            expressions = reader.call("(one pretty list) (and another)")

            expect(expressions).to eq [
              builder.create(sym("one"), sym("pretty"), sym("list")),
              builder.create(sym("and"), sym("another")),
            ]
          end
        end

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
        end
      end
    end
  end
end
