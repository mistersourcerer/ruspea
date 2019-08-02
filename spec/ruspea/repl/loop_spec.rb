require "stringio"

module Ruspea::Repl
  RSpec.describe Loop do
    subject(:looop) { described_class.new }

    def input(*lines)
      StringIO.new lines.join("\n")
    end

    describe "#run" do
      it "passes down the input to the reader" do
        expect {
          looop.run input: input("'hello", "(bye)")
        }.to output("hello\nSee you soon.\n").to_stdout
      end

      context "Handling errors" do
        it "doesn't explodes when an error happens" do
          evaler = ->(_) { raise Ruspea::Error::Standard.new }

          expect {
            looop.run input: input("1"), evaler: evaler
          }.to_not raise_error
        end

        it "shows error messages nicely" do
          evaler = ->(_) { raise Ruspea::Error::Standard.new("omg") }

          expect {
            looop.run input: input("1"), evaler: evaler
          }.to output([
            "Ruspea::Error::Standard",
            "omg",
            "See you soon.\n",
          ].join("\n")).to_stdout
        end
      end
    end
  end
end
