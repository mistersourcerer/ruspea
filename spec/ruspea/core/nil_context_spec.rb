module Ruspea
  RSpec.describe Core::NilContext.instance do
    subject(:nil_ctx) { described_class }

    describe "#defined?" do
      it "always return false for #defined?" do
        expect(nil_ctx.defined?("lol")).to eq false

        nil_ctx["lol"] = true

        expect(nil_ctx.defined?("lol")).to eq false
      end
    end

    describe "#[]" do
      it "always raise when trying to #resolve" do
        expect { nil_ctx["lol"] }.to raise_error Error::Execution
      end
    end

    describe "#around" do
      it "returns the context passed to #around" do
        ctx = Core::Context.new

        expect(nil_ctx.around(ctx)).to be ctx
      end
    end
  end
end
