module Ruspea::Interpreter
  RSpec.describe Reader do
    subject(:reader) { described_class.new }
    let(:list) { Ruspea::Runtime::List }
    let(:sym) { Ruspea::Runtime::Sym }
    let(:form) { Ruspea::Interpreter::Form }
    let(:nill) { Ruspea::Runtime::Nill.instance }

    it "reads strings" do
      expect(reader.call('"hello" "world"')).to eq [nill, [
        form.new("hello"),
        form.new("world")
      ]]
    end

    it "reads integers and floats" do
      expect(reader.call("1 -2 4.2_0 -13.3")).to eq [nill, [
        form.new(1),
        form.new(-2),
        form.new(4.2),
        form.new(-13.3)
      ]]
    end

    it "reads nil" do
      expect(reader.call("nil")).to eq [nill, [
        form.new(nil)
      ]]
    end

    it "reads lists" do
      expect(reader.call('(1 "2") (3.0, -4)')).to eq [nill, [
        form.new(list.create(form.new(1), form.new("2"))),
        form.new(list.create(form.new(3.0), form.new(-4))),
      ]]
    end

    it "reads nested lists" do
      expect(reader.call('(1 (2 (3 4) ("5" (6))))')).to eq [nill, [
        form.new(list.create(
          form.new(1),
          form.new(list.create(
            form.new(2),
            form.new(
              list.create(form.new(3), form.new(4))),
            form.new(
              list.create(
                form.new("5"),
                form.new(list.create(form.new(6)))))
          ))
        )),
      ]]
    end

    it "reads symbols" do
      expect(reader.call("lol")).to eq [nill, [form.new(sym.new("lol"))]]
      expect(reader.call('"omg" lol bbq')).to eq [nill, [
        form.new("omg"),
        form.new(sym.new("lol")),
        form.new(sym.new("bbq"))
      ]]
    end

    it "reads arrays" do
      code = '[1 [2, "3" [four 5]], (6 7)]'
      expect(reader.call(code)).to eq [nill, [
        form.new([
          form.new(1),
          form.new([
            form.new(2),
            form.new("3"),
            form.new([form.new(sym.new("four")), form.new(5)])
          ]), form.new(list.create(form.new(6), form.new(7)))
        ])
      ]]
    end

    it "reads booleans" do
      expect(reader.call("true")).to eq [nill, [form.new(true)]]
      expect(reader.call("false")).to eq [nill, [form.new(false)]]
    end

    context "function declarations" do
      it "reads function declaration" do
        code = '(fn [omg lol] (print omg) (puts lol) "4.20")'
        expect(reader.call(code)).to eq [nill, [
          form.new(list.create(
            form.new(sym.new("fn")),
            form.new([
              form.new(sym.new("omg")),
              form.new(sym.new("lol"))
            ]),
            form.new(list.create(
                form.new(sym.new("print")),
                form.new(sym.new("omg"))
            )),
            form.new(list.create(
                form.new(sym.new("puts")),
                form.new(sym.new("lol"))
            )),
            form.new("4.20")
          ))
        ]]
      end

      it "recognizes declaration without params" do
        code = '(fn [] (print omg) (puts lol) "4.20")'

        expect(reader.call(code)).to eq [nill, [
          form.new(list.create(
            form.new(sym.new("fn")),
            form.new([]),
            form.new(list.create(
              form.new(sym.new("print")), form.new(sym.new("omg"))
            )),
            form.new(list.create(
              form.new(sym.new("puts")), form.new(sym.new("lol"))
            )),
            form.new("4.20")
          ))
        ]]
      end
    end

    context "quoting" do
      it "recognizes list quoting" do
        expect(reader.call("'(1 \"2\" three)")).to eq([nill, [
          form.new(list.create(
            form.new(sym.new("quote")),
            form.new(list.create(
              form.new(1),
              form.new("2"),
              form.new(sym.new("three"))
            ))
          ))
        ]])
      end

      it "recognizes symbol quoting" do
        expect(reader.call("'omg")).to eq([nill, [
          form.new(list.create(
            form.new(sym.new("quote")),
            form.new(sym.new("omg"))
          ))
        ]])
      end
    end

    context "cond" do
      it "recognizes a call to cond" do
        code = "(cond\nfalse (lol 1)\ntrue (bbq 2))"

        expect(reader.call(code)).to eq([nill, [
          form.new(list.create(
            form.new(sym.new("cond")),
            form.new(false),
            form.new(list.create(
              form.new(sym.new("lol")), form.new(1)
            )),
            form.new(true),
            form.new(list.create(
              form.new(sym.new("bbq")), form.new(2),
            ))
          ))
        ]])
      end
    end
  end
end
