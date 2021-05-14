module Ruspea
  RSpec.describe Core::Context do
    let(:env) { Core::Environment.new.tap { |e| e["lol"] = 420 } }
    let(:evaluator) { Evaluator.new }
    subject(:ctx) { described_class.new(evaluator, env) }

    context "Bindings and fallback" do
      it "ensures wrapped environment falls back into outer one" do
        expect(ctx["lol"]).to eq 420
      end

      it "overrides bindings from wrapper" do
        ctx["lol"] = "bbq"

        expect(ctx["lol"]).to eq "bbq"
      end

      it "changes in the new env don't reflect on the wrapper" do
        ctx["lol"] = "bbq"

        expect(ctx["lol"]).to eq "bbq"
        expect(env["lol"]).to eq 420
      end
    end

    describe "#eval" do
      it "delegates to call to the evaluator with self as environment" do
        allow(evaluator).to receive(:eval)
        ctx.eval(1)

        expect(evaluator).to have_received(:eval).with(1, ctx)
      end
    end

    describe "#bound?" do
      it "returns true if symbol is bound in the current context" do
        ctx["omg"] = "bbq"
        expect(ctx.bound?("omg")).to eq true
      end

      it "returns true if symbol is bound in the fallback environment" do
        expect(ctx.bound?("lol")).to eq true
      end
    end
  end
end
