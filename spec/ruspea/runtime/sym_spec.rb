module Ruspea::Runtime
  RSpec.describe Sym do
    describe "#to_s" do
      it "returns the symbol id" do
        expect(Sym.new("much_symbolic").to_s).to eq "much_symbolic"
      end
    end

    describe "#eql?" do
      it "returns true for two Sym with same id" do
        expect(Sym.new("wow")).to eq Sym.new("wow")
        expect(Sym.new("wow").eql? Sym.new("wow")).to eq true
        expect(Sym.new("wow") == Sym.new("wow")).to eq true
        expect(Sym.new("wow").hash == Sym.new("wow").hash).to eq true
        expect(Sym.new("wow") == Sym.new("lol")).to eq false
      end
    end
  end
end
