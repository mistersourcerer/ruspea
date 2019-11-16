module Ruspea::Interpreter
  RSpec.describe Position do
    subject(:position) { described_class.new(1, 1) }

    describe "#+" do
      it "sums the parameter to the current column number" do
        expect(position + 4).to eq described_class.new(5, 1)
      end

      it "sums array with position (two elements) creating new Position" do
        expect(position + [4, 4]).to eq described_class.new(5, 5)
      end
    end
  end
end
