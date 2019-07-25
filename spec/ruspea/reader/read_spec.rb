module Ruspea::Reader
  RSpec.describe Read do
    let(:builder) { Ruspea::Runtime::List }
    subject(:reader) { described_class.new }

    describe "#call" do
      context "lisping!" do
        it "knows how to read a list" do
          expect(
            reader.call("(one pretty list)")
          ).to eq builder.create("one", "pretty", "list")
        end
      end
    end
  end
end
