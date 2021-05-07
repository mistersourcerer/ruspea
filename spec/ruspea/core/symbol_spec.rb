module Ruspea
  RSpec.describe Core::Symbol do
    subject(:symbol) { described_class.new "lol" }

    describe "#inspect" do
      it "returns the quote representation for the symbol" do
        expect(symbol.inspect).to eq "'lol"
      end
    end
  end
end
