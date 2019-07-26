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
              {
                form: builder.create(sym("one"), sym("pretty"), sym("list")),
                closed: true,
              }
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
        end

        context "multiple expressions" do
          it "creates one 'node' for each expression found" do
            expressions = reader.call("(one pretty list) (and another)")

            expect(expressions).to eq [
              {
                form: builder.create(
                  sym("one"), sym("pretty"), sym("list")),
                closed: true,
              },
              {
                form: builder.create(sym("and"), sym("another")),
                closed: true,
              },
            ]
          end
        end
      end
    end
  end
end
