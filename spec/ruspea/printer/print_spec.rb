module Ruspea::Printer
  RSpec.describe Print do
    class Printable
      def print
        "here I am"
      end
    end

    class NonPrintable
      def inspect
        "non-printable"
      end
    end

    subject(:printer) { described_class.new }

    describe "#call" do
      it "relies on the underlying form (#print)" do
        expect {
          printer.call(Printable.new)
        }.to output("here I am").to_stdout
      end

      it "prints the value and the class of non-printables" do
        expect {
          printer.call(NonPrintable.new)
        }.to output("non-printable /* ::Ruspea::Printer::NonPrintable */").to_stdout
      end

      it "prints strings with quotation" do
        expect {
          printer.call "this is a ruby string"
        }.to output('"this is a ruby string"').to_stdout
      end

      it "prints true and false as 'yes' and 'no'" do
        expect { printer.call true }.to output("yes").to_stdout
        expect { printer.call false }.to output("no").to_stdout
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
