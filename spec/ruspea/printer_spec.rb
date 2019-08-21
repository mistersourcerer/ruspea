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
      let(:list) { Ruspea::Runtime::List }
      let(:sym) { Ruspea::Runtime::Sym }

      it "prints the internal contents of a list" do
        value = list.create(sym.new("lol"), "omg", 1, 4.2)

        expect(printer.call(value)).to eq ("(lol \"omg\" 1 4.2)")
      end

      it "prints nested lists" do
        value = list.create(
          sym.new("yas"),
          list.create(
            1,
            list.create(2, list.create(3))
          )
        )

        expect(printer.call(value)).to eq ("(yas (1 (2 (3))))")
      end

      it "uses elipses if list has more than 10 elements" do
        value = list.create(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 420)

        expect(printer.call(value)).to eq ("(1 2 3 4 5 6 7 8 9 10 ...) # count: 14")
      end
    end
  end
end
