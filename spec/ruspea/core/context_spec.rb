module Ruspea
  RSpec.describe Core::Context do
    subject(:ctx) { described_class.new }

    before do
      ctx[:subject] = true
    end

    describe "#around" do
      it "creates a new context where the current one is a fallback for the new" do
        new_ctx = described_class.new { |c| c[:new] = true }
        final = ctx.around new_ctx

        expect(final[:new]).to eq true
        expect(final[:subject]).to eq true
        expect(final).to_not be ctx
        expect(final).to_not be new_ctx
      end
    end

    describe "#resolve" do
      it "allows for wrapped context to override wrapper values" do
        new_ctx = described_class.new { |c| c[:subject] = "another" }
        final = ctx.around new_ctx

        expect(final[:subject]).to eq "another"
      end
    end
  end
end
