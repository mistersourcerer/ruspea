module Ruspea::Repl
  RSpec.describe Printer do
    class Printable
      def print
        "here I am"
      end
    end

    subject(:printer) { described_class.new }

    describe "#print" do
      it "relies on the underlying form (#print)" do
        expect {
          printer.print(Printable.new)
        }.to output("here I am").to_stdout
      end

      it "prints the value and the class of non-printables" do
        expect {
          printer.print(1)
        }.to output("1 // Ruby.Integer").to_stdout
      end
    end

    describe "#puts" do
      it "puts a string into the stdout" do
        expect {
          printer.puts("tchussie")
        }.to output("tchussie\n").to_stdout
      end
    end
  end
end
