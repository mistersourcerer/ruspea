module Ruspea::Reader
  RSpec.describe Read do
    subject(:reader) { described_class.new }

    it "ignores spaces and commas" do
      expect(reader.call(", , ,")).to eq []
    end

    it "ignores blank lines" do
      expect(reader.call("\n\n")).to eq []
    end

    it "recognizes delimited strings" do
      expect(reader.call("\"hello world\"")).to eq [
        {
          type: String,
          content: "hello world",
          closed: true
        }
      ]
    end

    it "recognizes open string" do
      expect(reader.call("\"hello world")).to eq [
        {
          type: String,
          content: "hello world",
          closed: false
        }
      ]
    end

    it "treats spaces, commas and new lines as separators" do
      code = '"hello" "brave"' + "\n" + '"new","world"'

      expect(reader.call(code)).to eq [
        {
          type: String,
          content: "hello",
          closed: true
        },
        {
          type: String,
          content: "brave",
          closed: true
        },
        {
          type: String,
          content: "new",
          closed: true
        },
        {
          type: String,
          content: "world",
          closed: true
        }
      ]
    end
  end
end
