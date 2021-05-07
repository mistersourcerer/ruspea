module Ruspea
  RSpec.describe Core::Symbol do
    subject(:symbol) { Core::Symbol.new "lol" }

    describe "#inspect" do
      it "returns the quote representation for the symbol" do
        expect(symbol.inspect).to eq "'lol"
      end
    end
  end
end
