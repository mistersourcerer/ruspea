module Ruspea::Interpreter
  RSpec.describe Evaler do
    subject(:evaler) { described_class.new }
    let(:sym) { Ruspea::Runtime::Sym }
    let(:env) { Ruspea::Runtime::Env }
    let(:list) { Ruspea::Runtime::List }

    describe "#call" do
      it "evaluates symbol to it's value in the context" do
        number = sym.new("number")
        cxt = env.new.tap { |e| e.define number, 420 }

        result = evaler.call Form.new(number), context: cxt
        expect(result).to eq 420
      end

      it "evaluates Numerics to themselves" do
        expect(evaler.call(Form.new(420))).to eq 420
      end

      it "evaluates Strings to themselves" do
        expect(evaler.call(Form.new("hello world"))).to eq "hello world"
      end

      it "evaluates nil to nil" do
        expect(evaler.call(Form.new(nil))).to eq nil
      end

      context "Arrays" do
        it "evaluates Arrays to themselves" do
          array = Form.new([Form.new(1), Form.new(2)])
          expect(evaler.call(array)).to eq [1, 2]
        end

        it "evaluates each member of the array too" do
          core = Ruspea::Language::Core.new
          new_env = env.new(core).tap { |e|
            e.define sym.new("number"), 420
          }

          # [1 number (def omg "lol")]
          aform = Form.new([
            Form.new(1),
            Form.new(sym.new("number")),
            Form.new(list.create(
              Form.new(sym.new("def")),
              Form.new(sym.new("omg")),
              Form.new("lol")
            ))
          ])
          result = evaler.call(aform, context: new_env)

          expect(result).to eq [1, 420, "lol"]
          expect(new_env.call(sym.new("omg"))).to eq "lol"
        end
      end

      context "Booleans" do
        it "evaluates true" do
          expect(evaler.call(Form.new(true))).to eq true
        end

        it "evaluates false" do
          expect(evaler.call(Form.new(false))).to eq false
        end
      end

      context "Function delcarations" do
        it "creates a function and stores it in the caller context" do
          # (def omg (fn [lol] lol))
          declaration = Form.new(list.create(
            Form.new(sym.new("def")),
            Form.new(sym.new("omg")),
            Form.new(list.create(
              Form.new(sym.new("fn")),
              Form.new([sym.new("lol")]),
              Form.new(sym.new("lol"))
            ))
          ))

          # (omg 1) # => 1
          invocation = Form.new(list.create(
            Form.new(sym.new("omg")),
            Form.new(1)
          ))

          new_env = env.new(Ruspea::Language::Core.new)
          evaler.call(declaration, context: new_env)
          omg = new_env.lookup(sym.new("omg"))

          expect(omg).to be_a(Ruspea::Runtime::Lm)
          expect(evaler.call(invocation, context: new_env)).to eq 1
        end
      end
    end
  end
end
