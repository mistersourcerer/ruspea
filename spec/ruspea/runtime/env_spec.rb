module Ruspea::Runtime
  RSpec.describe Env do
    subject(:env) { described_class.new }

    describe "#define" do
      it "returns the value of a definition" do
        expect(env.define(Sym.new("lol"), 1)).to eq 1
      end
    end

    describe "#lookup" do
      it "returns the value associated with a Sym" do
        env.define Sym.new("lol"), 1

        expect(env.lookup(Sym.new("lol"))).to eq 1
      end

      it "raises if no association is found" do
        expect {
          env.lookup(Sym.new("omg"))
        }.to raise_error(Ruspea::Error::Resolution)

        expect {
          env.lookup(Sym.new("omg"))
        }.to raise_error("Unable to resolve: omg in the current context")
      end
    end
  end
end
