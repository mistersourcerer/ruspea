module Ruspea
  RSpec.describe Core do
    subject(:ds) { described_class }
    let(:evaler) { Evaler.new }

    describe Runtime::Map do
      it "translate a map form to runtime map" do
        expect(evaler.call(form("{some: \"value\"}")))
          .to eq(ds.new(some: "value"))
      end
    end
  end
end
