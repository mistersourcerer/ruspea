module Ruspea
  RSpec.describe Runtime::Map do
    subject(:map) { described_class.new }

    describe "#put" do
      it "creates a new map with the added value" do
        new_map = map.put(:some, "value")

        expect(new_map).to_not be(map)
        expect(new_map.get(:some)).to eq "value"
      end
    end
  end
end
