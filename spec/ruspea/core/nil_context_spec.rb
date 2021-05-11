module Ruspea
  RSpec.describe Core::NilContext.instance do
    subject(:nil_ctx) { described_class }

    it "always return false for #defined?" do
      expect(nil_ctx.defined?("lol")).to eq false

      nil_ctx["lol"] = true

      expect(nil_ctx.defined?("lol")).to eq false
    end

    it "always raise when trying to #resolve" do
      expect { nil_ctx["lol"] }.to raise_error Error::Execution
    end
  end
end