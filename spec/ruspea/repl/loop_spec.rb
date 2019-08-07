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
        }.to output("#user=> hello\n#user=> See you soon.\n").to_stdout
      end

      context "Handling errors" do
        it "doesn't explodes when an error happens" do
          evaler = ->(*_) { raise Ruspea::Error::Standard.new }

          expect {
            expect {
              looop.run input: input("1"), evaler: evaler
            }.to output.to_stdout
          }.to_not raise_error
        end

        it "shows error messages nicely" do
          evaler = ->(*_) { raise Ruspea::Error::Standard.new("omg") }

          expect {
            looop.run input: input("1"), evaler: evaler
          }.to output([
            "#user=> Ruspea::Error::Standard",
            "omg\n",
            "#user=> See you soon.\n",
          ].join("\n")).to_stdout
        end
      end

      context "Handling 'open' delimiters" do
        it "changes the prompt to wait for the closing of an Array" do
          code = "[1 2"
          expect {
            looop.run input: input(code)
          }.to output("#user?>").to_stdout
        end
      end
    end
  end
end
