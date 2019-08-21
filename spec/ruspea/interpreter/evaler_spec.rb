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
    end
  end
end
