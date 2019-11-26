module Ruspea
  include Printer::Matchers

  RSpec.describe Printer do
    subject(:printer) { described_class.new }

    describe Keyword do
      it "prints keyword" do
        expect(printer.print(:a)).to eq ":a"
      end
    end

    describe String do
      it "prints strings" do
        expect(printer.print("omg lol bbq")).to eq "\"omg lol bbq\""
      end
    end
  end
end
