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
    end
  end
end
