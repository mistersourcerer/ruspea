module Ruspea::Runtime
  RSpec.describe Sym do
    describe "#print" do
      it "returns the symbol id" do
        expect(Sym.new("much_symbolic").print).to eq "much_symbolic"
      end
    end
  end
end
