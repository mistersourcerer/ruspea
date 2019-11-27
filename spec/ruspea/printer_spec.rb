module Ruspea
  include Printer::Matchers

  RSpec.describe Printer do
    subject(:printer) { described_class.new }

    describe Keyword do
      it "prints keyword with : included" do
        expect(printer.print(:a)).to eq ":a"
      end
    end

    describe String do
      it "prints strings quoted" do
        expect(printer.print("omg lol bbq")).to eq "\"omg lol bbq\""
      end
    end

    describe Symbol do
      it "prints the symbol name" do
        expect(printer.print(Forms::Symbol.new("lol"))).to eq "lol"
      end
    end

    describe List do
      it "prints empty lists" do
        expect(printer.print(Runtime::Nill.instance)).to eq "()"
      end

      it "prints" do
        list = Runtime::List.create(1, 2, 3)
        expect(printer.print(list)).to eq "(1 2 3)"
      end
    end
  end
end
