module Ruspea::Interpreter
  RSpec.describe Parser, "Strings" do
    subject(:parser) { described_class.new }

    it "recognizes delimited strings" do
      expect(parser.call("\"hello world\"")).to eq [
        {
          type: String,
          content: "hello world",
          closed: true
        }
      ]
    end

    it "recognizes open string" do
      expect(parser.call("\"hello world")).to eq [
        {
          type: String,
          content: "hello world",
          closed: false
        }
      ]
    end

    it "treats spaces, commas and new lines as separators" do
      code = '"hello" "brave"' + "\n" + '"new","world"'

      expect(parser.call(code)).to eq [
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
