module Ruspea
  RSpec.describe Core::Environment do
    def sym(label)
      Core::Symbol.new label
    end

    subject(:env) { described_class.new }

    describe "#[]=" do
      it "binds a value to a symbol in the environment" do
        env[sym("lol")] = 420

        expect(env["lol"]).to eq 420
      end
    end

    describe "#[]" do
      it "raises if the symbol is unbounded" do
        expect { env[sym("lol")] }.to raise_error(
          Error::Execution,
          /Unable to resolve symbol: lol in this context/
        )
      end

      it "treats keys as symbols" do
        env["lol"] = 420

        expect(env["lol"]).to eq 420
        expect(env[:lol]).to eq 420
        expect(env[sym("lol")]).to eq 420
      end
    end

    describe "#bound?" do
      it "returns true for bounded and false for unbounded symbols" do
        env[sym("lol")] = 420

        expect(env.bound? sym("nada")).to eq false
        expect(env.bound? sym("lol")).to eq true
      end
    end
  end
end
