module Ruspea::Language
  RSpec.describe Core do
    subject(:core) { described_class.new }
    let(:evaler) { Ruspea::Interpreter::Evaler.new }
    let(:list) { Ruspea::Runtime::List }
    let(:sym) { Ruspea::Runtime::Sym }
    let(:user_env) { Ruspea::Runtime::Env.new(core) }

    context "quote" do
      it "allows quotation of expressions" do
        quotation = Ruspea::Runtime::List.create(
          Ruspea::Runtime::Sym.new("quote"),
          Ruspea::Runtime::Sym.new("omg")
        )

        result = evaler.call(quotation, context: core)
        expect(result).to eq Ruspea::Runtime::Sym.new("omg")
      end
    end

    context "def" do
      it "defines a value associated with a symbol in the caller context" do
        definition = Ruspea::Runtime::List.create(
          Ruspea::Runtime::Sym.new("def"),
          Ruspea::Runtime::Sym.new("lol"),
          420
        )

        user_env = Ruspea::Runtime::Env.new(core)

        evaler.call(definition, context: user_env)
        expect(user_env.lookup(Ruspea::Runtime::Sym.new("lol"))).to eq 420

        # ensure the external context is not poluted:
        expect {
          core.lookup(Ruspea::Runtime::Sym.new("lol"))
        }.to raise_error Ruspea::Error::Resolution
      end
    end

    context "cond" do
      it "returns evaluates the expression for the first 'true' tuple" do
        user_env.define sym.new("lol"), 420

        invocation = list.create(
          sym.new("cond"),
          [
            [false, 1],
            [false, 2],
            [false, 3],
            [true, sym.new("lol")],
            [true, 5],
          ]
        )

        expect(evaler.call(invocation, context: user_env)).to eq 420
      end

      it "returns nil if no test is 'true'" do
        invocation = list.create(
          sym.new("cond"),
          [
            [false, 1],
            [false, 2],
            [false, 3],
            [false, 4],
            [false, 5],
          ]
        )

        expect(evaler.call(invocation, context: user_env)).to eq nil
      end
    end
  end
end
