module Ruspea
  RSpec.describe Core::Symbol do
    subject(:symbol) { described_class.new "lol" }

    context "equality" do
      it "knows when two symbols are equal" do
        expect(symbol == described_class.new("lol")).to eq true
        expect(symbol.eql? described_class.new("lol")).to eq true
      end
    end

    describe "#hash" do
      it "relies on label for hash-keying" do
        expect(symbol.hash).to eq "lol".hash
      end
    end

    describe "#inspect" do
      it "returns the quote representation for the symbol" do
        expect(symbol.inspect).to eq "'lol"
      end
    end

    describe "#to_s" do
      it "returns the label for the symbol" do
        expect(symbol.to_s).to eq "lol"
      end
    end
  end
end
