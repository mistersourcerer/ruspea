module Ruspea::Language
  RSpec.describe Core do
    subject(:core) { described_class.new }
    let(:evaler) { Ruspea::Interpreter::Evaler.new }

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
  end
end
