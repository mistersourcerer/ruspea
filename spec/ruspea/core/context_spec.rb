module Ruspea
  RSpec.describe Core::Context do
    let(:env) { Core::Environment.new.tap { |e| e["lol"] = 420 } }
    subject(:ctx) { described_class.new(Evaluator.new, env) }

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
  end
end
