module Ruspea::Runtime
  RSpec.describe Keyword do
    describe "#print" do
      it "returns the keyword id" do
        expect(Keyword.new("much_symbolic").print).to eq "much_symbolic"
        expect(Keyword.new("much_symbolic:").print).to eq "much_symbolic"
      end
    end

    describe "#eql?" do
      it "returns true for two Sym with same id" do
        expect(Keyword.new("wow")).to eq Keyword.new("wow")
        expect(Keyword.new("wow:")).to eq Keyword.new("wow")
        expect(Keyword.new("wow").eql? Keyword.new("wow")).to eq true
        expect(Keyword.new("wow") == Keyword.new("wow")).to eq true
        expect(Keyword.new("wow").hash == Keyword.new("wow").hash).to eq true
        expect(Keyword.new("wow") == Keyword.new("lol")).to eq false
      end
    end
  end
end
