module Ruspea::Interpreter
  RSpec.describe Reader do
    subject(:reader) { described_class.new }
    let(:list) { Ruspea::Runtime::List }
    let(:sym) { Ruspea::Runtime::Sym }

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

    it "reads symbols" do
      expect(reader.call("lol")).to eq [sym.new("lol")]
      expect(reader.call('"omg" lol bbq')).to eq [
        "omg", sym.new("lol"), sym.new("bbq")
      ]
    end

    it "reads arrays" do
      code = '[1 [2, "3" [four 5]], (6 7)]'
      expect(reader.call(code)).to eq [
        [1, [2, "3", [sym.new("four"), 5]], list.create(6, 7)]
      ]
    end

    it "reads booleans" do
      expect(reader.call("true")).to eq [true]
      expect(reader.call("false")).to eq [false]
    end

    context "function declarations" do
      it "reads function declaration" do
        code = '(fn [omg lol] (print omg) (puts lol) "4.20")'
        expect(reader.call(code)).to eq [
          list.create(
            sym.new("fn"),
            [sym.new("omg"), sym.new("lol")],
            [
              list.create(sym.new("print"), sym.new("omg")),
              list.create(sym.new("puts"), sym.new("lol")),
              "4.20"
            ]
          )
        ]
      end

      it "recognizes declaration without params" do
        code = '(fn [] (print omg) (puts lol) "4.20")'
        expect(reader.call(code)).to eq [
          list.create(
            sym.new("fn"),
            [],
            [
              list.create(sym.new("print"), sym.new("omg")),
              list.create(sym.new("puts"), sym.new("lol")),
              "4.20"
            ]
          )
        ]
      end

      it "raises syntax error if no params given" do
        message = <<~m
          fn first parameter should be an Array
          for a zero arity function, use (fn [] ...)
        m
        code = '(fn (print omg) (puts lol) "4.20")'
        expect { reader.call(code) }
          .to raise_error(Ruspea::Error::Syntax, message)
      end
    end
  end
end
