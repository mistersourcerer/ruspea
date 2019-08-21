module Ruspea
  RSpec.describe Printer do
    subject(:printer) { described_class.new }

    it "prints strings" do
      expect(printer.call("lol")).to eq("\"lol\"")
    end

    it "prints numbers" do
      expect(printer.call(1)).to eq("1")
      expect(printer.call(4.20)).to eq("4.2")
    end

    it "prints symbols" do
      expect(printer.call(Ruspea::Runtime::Sym.new("lol"))).to eq("lol")
    end

    context "lists" do

    end
  end
end
