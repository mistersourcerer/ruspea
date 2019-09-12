module Ruspea::Interpreter
  RSpec.describe Evaler do
    subject(:evaler) { described_class.new }
    let(:reader) { Reader.new }
    let(:sym) { Ruspea::Runtime::Sym }
    let(:env) { Ruspea::Runtime::Env }
    let(:list) { Ruspea::Runtime::List }

    describe "#call" do
      it "evaluates symbol to it's value in the context" do
        cxt = env.new.tap { |e| e.define sym.new("number"), 420 }
        _, forms = reader.call("number")

        result = evaler.call forms.first, context: cxt
        expect(result).to eq 420
      end

      it "evaluates Numerics to themselves" do
        _, forms = reader.call("420")
        expect(evaler.call(forms.first)).to eq 420
      end

      it "evaluates Strings to themselves" do
        _, forms = reader.call('"hello world"')
        expect(evaler.call(forms.first)).to eq "hello world"
      end

      it "evaluates nil to nil" do
        _, forms = reader.call("nil")
        expect(evaler.call(forms.first)).to eq nil
      end

      context "Arrays" do
        it "evaluates Arrays to themselves" do
          _, forms = reader.call("[1 2]")
          expect(evaler.call(forms.first)).to eq [1, 2]
        end

        it "evaluates each member of the array too" do
          core = Ruspea::Language::Core.new
          cxt = env.new(core).tap { |e| e.define sym.new("number"), 420 }

          _, forms = reader.call('[1 number (def omg "lol")]')

          result = evaler.call(forms.first, context: cxt)

          expect(result).to eq [1, 420, "lol"]
          expect(cxt.call(sym.new("omg"))).to eq "lol"
        end
      end

      context "Booleans" do
        it "evaluates true" do
          _, forms = reader.call("true")
          expect(evaler.call(forms.first)).to eq true
        end

        it "evaluates false" do
          _, forms = reader.call("false")
          expect(evaler.call(forms.first)).to eq false
        end
      end

      context "Function delcarations" do
        it "creates a function and stores it in the caller context" do
          _, declaration = reader.call("(def omg (fn [lol] lol))")
          _, invocation = reader.call("(omg 1)")

          new_env = env.new(Ruspea::Language::Core.new)
          evaler.call(declaration.first, context: new_env)
          omg = new_env.lookup(sym.new("omg"))

          expect(omg).to be_a(Ruspea::Runtime::Fn)
          expect(evaler.call(invocation.first, context: new_env)).to eq 1
        end
      end
    end
  end
end
