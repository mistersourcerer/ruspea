module Ruspea::Repl
  RSpec.describe Reader do
    subject(:reader) { described_class.new }

    describe "#read" do
      it "delegates the reading to the underlinying reader" do
        actual_reader = double(Ruspea::Reader::Read)
        expect(actual_reader).to receive(:call).with("123")

        expect(reader.read("123", reader: actual_reader))
      end
    end
  end
end
