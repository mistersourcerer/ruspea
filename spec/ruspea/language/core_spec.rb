module Ruspea::Language
  RSpec.describe Core do
    subject(:core) { described_class.new }
    let(:reader) { Ruspea::Interpreter::Reader.new }
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
        code = <<~code
          (cond
            (false 1)
            (false 2)
            (false 3)
            (true (def lol 420) lol)
            (true 5))
        code
        _, forms = reader.call(code)

        expect(evaler.call(forms.last, context: user_env)).to eq 420
      end

      it "returns nil if no test is 'true'" do
        code = <<~code
          (cond
            (false 1)
            (false 2)
            (false 3))
        code
        _, forms = reader.call(code)

        expect(evaler.call(forms.last, context: user_env)).to eq nil
      end
    end

    context "::" do
      it "constanize single elements" do
        _, forms = reader.call("(:: Kernel)")

        expect(evaler.call(forms.first, context: user_env)).to eq Kernel
      end

      it "constanize namespaced elements" do
        _, forms = reader.call("(:: Ruspea::Runtime::List)")

        expect(evaler.call(forms.first, context: user_env)).to eq list
      end
    end

    context "." do
      it "sends a method to any object" do
        _, forms = reader.call('(. "lol" upcase)')

        expect(evaler.call(forms.first, context: user_env)).to eq "LOL"
      end

      it "sends parameters to a object" do
        code = [
          '(def str "bbq")',
          '(. "lol" << str)',
          "(. 1 + 1)",
          "(. [] << 'bbq)"
        ].join("\n")
        _, forms = reader.call(code)

        expect(evaler.call(forms, context: user_env)).to eq [
          "bbq", "lolbbq", 2, [sym.new("bbq")]]
      end

      it "sends parameters to objects" do
        code = [
          '(def str "bbq")',
          '(. (:: String) new "lol")',
          '(. (. (:: Array) new) << (. 1 + 2))',
          '(. (:: Kernel) print str)'
        ].join("\n")
        _, forms = reader.call(code)

        result = nil
        expect {
          result = evaler.call(forms, context: user_env)
        }.to output("bbq").to_stdout
        expect(result).to eq ["bbq", "lol", [3], nil]
      end
    end

    context "rsp core" do
      it "loads rsp core" do
        expect { user_env.lookup(sym.new("puts")) }.to_not raise_error
      end
    end
  end
end
