module Ruspea::Language
  RSpec.describe Core do
    subject(:core) { described_class.new }
    let(:evaler) { Ruspea::Interpreter::Evaler.new }
    let(:list) { Ruspea::Runtime::List }
    let(:sym) { Ruspea::Runtime::Sym }
    let(:form) { Ruspea::Interpreter::Form }
    let(:user_env) { Ruspea::Runtime::Env.new(core) }

    context "quote" do
      it "allows quotation of symbols" do
        # (quote omg)
        quotation = form.new(list.create(
          form.new(sym.new("quote")),
          form.new(sym.new("omg"))
        ))

        result = evaler.call(quotation, context: core)
        expect(result).to eq sym.new("omg")
      end

      it "allows quotation of lists" do
        # (quote (1 2))
        quotation = form.new(list.create(
          form.new(sym.new("quote")),
          form.new(
            list.create(1, 2)
          )
        ))

        result = evaler.call(quotation, context: core)
        expect(result).to eq list.create(1, 2)
      end
    end

    context "def" do
      it "defines a value associated with a symbol in the caller context" do
        definition = form.new(list.create(
          form.new(sym.new("def")),
          form.new(sym.new("lol")),
          form.new(420)
        ))

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
        # (cond
        #   false 1
        #   false 2
        #   false 3
        #   true lol
        #   true 5)
        user_env.define sym.new("lol"), 420

        invocation = form.new(list.create(
          form.new(sym.new("cond")),
          form.new(false), form.new(1),
          form.new(false), form.new(2),
          form.new(false), form.new(3),
          form.new(true), form.new(sym.new("lol")),
          form.new(false), form.new(5),
        ))

        expect(evaler.call(invocation, context: user_env)).to eq 420
      end

      it "returns nil if no test is 'true'" do
        invocation = form.new(list.create(
          form.new(sym.new("cond")),
          form.new(false), form.new(1),
          form.new(false), form.new(2),
          form.new(false), form.new(3),
          form.new(false), form.new(5),
        ))

        expect(evaler.call(invocation, context: user_env)).to eq nil
      end
    end
  end
end
