module Ruspea::Interpreter
  RSpec.describe Reader do
    subject(:reader) { described_class.new }
    let(:list) { Ruspea::Runtime::List }

    it "reads strings" do
      expect(reader.call('"hello" "world"')).to eq ["hello", "world"]
    end

    it "reads integers and floats" do
      expect(reader.call("1 -2 4.2_0 -13.3")).to eq [
        1, -2, 4.2, -13.3
      ]
    end

    it "reads lists" do
      expect(reader.call('(1 "2") (3.0, -4)')).to eq [
        list.create(1, "2"),
        list.create(3.0, -4)
      ]
    end

    it "reads nested lists" do
      expect(reader.call('(1 (2 (3 4) ("5" (6))))')).to eq [
        list.create(
          1,
          list.create(
            2,
            list.create(3, 4),
            list.create("5", list.create(6))
          )
        ),
      ]
    end
  end
end
