module Ruspea::Interpreter
  RSpec.describe Evaler do
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

      context "invocations" do
        it "treats Lists as function invocation" do
          fn_name = Ruspea::Runtime::Sym.new("fn")
          fn = Ruspea::Runtime::Lm.new body: [420]
          cxt = Ruspea::Runtime::Env.new.tap { |env| env.define fn_name, fn }

          list = Ruspea::Runtime::List.create fn_name

          result = evaler.call list, context: cxt
          expect(result).to eq 420
        end

        it "raises if no function with the given name is found" do
          list = Ruspea::Runtime::List.create Ruspea::Runtime::Sym.new("no")

          expect {
            evaler.call(list)
          }.to raise_error Ruspea::Error::Resolution
        end

        it "raises if list.head ! respond_to? :call"

        it "evaluates the parameters before calling the function" do
          # (def number 420)
          # (defn fn [number_arg] number_arg)
          # (fn number) => 420
          # (fn 13) => 13

          fn_name = Ruspea::Runtime::Sym.new("fn")
          number = Ruspea::Runtime::Sym.new("number")
          fn = Ruspea::Runtime::Lm.new(
            params: [Ruspea::Runtime::Sym.new("number_arg")],
            body: [Ruspea::Runtime::Sym.new("number_arg")],
          )
          ctx = Ruspea::Runtime::Env.new.tap { |env|
            env.define fn_name, fn
            env.define number, 420
          }

          list = Ruspea::Runtime::List.create(
            fn_name,
            Ruspea::Runtime::Sym.new("number")
          )
          list_with_13 = Ruspea::Runtime::List.create(fn_name, 13)

          expect(evaler.call(list, context: ctx)).to eq 420
          expect(evaler.call(list_with_13, context: ctx)).to eq 13
        end
      end
    end
  end
end
