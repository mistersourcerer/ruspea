module Ruspea
  RSpec.describe Printer do
    subject(:printer) { described_class.new }
    let(:list) { Ruspea::Runtime::List }
    let(:sym) { Ruspea::Runtime::Sym }
    let(:lmbd) { Ruspea::Runtime::Lmbd }

    it "prints strings" do
      expect(printer.call("lol")).to eq("\"lol\"")
    end

    it "prints numbers" do
      expect(printer.call(1)).to eq("1")
      expect(printer.call(4.20)).to eq("4.2")
    end

    it "prints symbols" do
      expect(printer.call(sym.new("lol"))).to eq("lol")
    end

    context "lists" do

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

        expect(printer.call(value))
          .to eq "(1 2 3 4 5 6 7 8 9 10 ...) # count: 14"
      end
    end # lists

    context "Functions" do
      it "prints function params and body" do
        raise "Not yet!"

        fun = lmbd.new(
          params: [sym.new("lol"), sym.new("bbq")],
          body: [
            list.create(sym.new("puts"), sym.new("lol")),
            list.create(sym.new("puts"), sym.new("bbq")),
            4.2
          ]
        )

        expect(printer.call(fun)).to eq(
          "(fn [lol bbq]\n" +
          "  (puts lol)\n" +
          "  (puts bbq)\n" +
          "  4.2)"
        )
      end

      it "if body is a ruby proc, says the function is 'internal'" do
        noop = ->(_) {}
        fun = lmbd.new(
          params: [sym.new("lol"), sym.new("bbq")],
          body: noop
        )

        expect(printer.call(fun)).to eq(
          "(fn [lol bbq]\n" +
          "  #- internal -#\n" +
          "  #{noop.inspect})"
        )
      end
    end
  end
end
