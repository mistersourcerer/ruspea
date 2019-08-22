module Ruspea::Interpreter
  RSpec.describe Evaler do
    include Ruspea::Runtime

    subject(:evaler) { described_class.new }

    describe "#call" do
      it "evaluates symbol to it's value in the context" do
        number = Ruspea::Runtime::Sym.new("number")
        cxt = Ruspea::Runtime::Env.new.tap { |env| env.define number, 420 }

        result = evaler.call number, context: cxt
        expect(result).to eq 420
      end

      it "evaluates Numerics to themselves" do
        expect(evaler.call(420)).to eq 420
      end

      it "evaluates Strings to themselves" do
        expect(evaler.call("hello world")).to eq "hello world"
      end

      context "Arrays" do
        it "evaluates Arrays to themselves" do
          expect(evaler.call([1, 2])).to eq [1, 2]
        end

        it "evaluates each member of the array too" do
          core = Ruspea::Language::Core.new
          env = Ruspea::Runtime::Env.new(core).tap { |env|
            env.define Ruspea::Runtime::Sym.new("number"), 420
          }

          # [1 number (def omg "lol")]
          expression = [
            1,
            Ruspea::Runtime::Sym.new("number"),
            Ruspea::Runtime::List.create(
              Ruspea::Runtime::Sym.new("def"),
              Ruspea::Runtime::Sym.new("omg"),
              "lol"
            )
          ]
          result = evaler.call(expression, context: env)

          expect(result).to eq [1, 420, "lol"]
          expect(env.call(Ruspea::Runtime::Sym.new("omg"))).to eq "lol"
        end
      end

      context "Function delcarations" do
        let(:list) { Ruspea::Runtime::List }
        let(:sym) { Ruspea::Runtime::Sym }

        it "creates a function and stores it in the caller context" do
          # (def omg (fn [lol] lol))
          declaration = list.create(
            sym.new("def"),
            sym.new("omg"),
            list.create(
              sym.new("fn"),
              [sym.new("lol")],
              [sym.new("lol")]
            )
          )

          # (omg 1) # => 1
          invocation = list.create(
            sym.new("omg"),
            1
          )

          env = Ruspea::Runtime::Env.new(Ruspea::Language::Core.new)
          evaler.call(declaration, context: env)
          omg = env.lookup(sym.new("omg"))

          expect(omg).to be_a(Ruspea::Runtime::Lm)
          expect(evaler.call(invocation, context: env)).to eq 1
        end
      end
    end
  end
end
