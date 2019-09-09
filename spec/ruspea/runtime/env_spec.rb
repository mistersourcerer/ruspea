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

      context "Finding symbols on an external context" do
        subject(:new_env) { described_class.new(env) }

        it "falls back to the external context can't resolve the symbol" do
          env.define Sym.new("lol"), 4.20

          expect(new_env.lookup(Sym.new("lol"))).to eq 4.20
        end

        it "overrides symbols in the external context" do
          env.define Sym.new("lol"), 4.20
          new_env.define Sym.new("lol"), "Nein, nein, nein!"

          expect(new_env.lookup(Sym.new("lol"))).to eq "Nein, nein, nein!"
        end
      end
    end

    describe "#call, allow Env to be treated as a normal function" do
      before do
        pending
        env.call([Sym.new("bbq"), 4.20])
      end

      it "defines a new symbol when arity is 2" do
        expect(env.lookup(Sym.new("bbq"))).to eq 4.20
      end

      it "returns the value associated with the sym when arity is 1" do
        expect(env.call([Sym.new("bbq")])).to eq 4.20
      end
    end

    context "equality test" do
      it "considers the internal table and the context"
    end
  end
end
