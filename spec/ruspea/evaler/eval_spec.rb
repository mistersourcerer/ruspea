module Ruspea::Evaler
  RSpec.describe Eval do
    let(:builder) { Ruspea::Runtime::List }
    let(:env) { Ruspea::Runtime::Env }
    subject(:evaler) { described_class.new }

    def sym(string)
      Ruspea::Runtime::Sym.new string
    end

    context "function calls" do
      it "delegates the fn to the underlying Lisp XD" do
        fake_lisp = double("Lisp")
        allow(fake_lisp)
          .to receive(:lol)
          .and_return 1
        invocation = builder.create sym("lol"), sym("param")

        expect(evaler.call(invocation, lisp: fake_lisp)).to eq 1
      end
    end

    context "quoting" do
      it "returns quoted lists" do
        invocation = builder.create(
          sym("quote"),
          builder.create(sym("def"), sym("omg"), 1)
        )

        expect(evaler.call(invocation)).to eq builder.create(
          sym("def"), sym("omg"), 1)
      end
    end

    context "symbol resolution" do
      it "resolves symbols to it's environment values" do
        ctx = env.new.tap { |e| e.define sym("lol"), 4.20 }

        expect(evaler.call(sym("lol"), env: ctx)).to eq 4.20
      end

      it "raises when symbol is not resolvable" do
        expect {
          evaler.call(sym("lol"))
        }.to raise_error Ruspea::Error::Resolution
      end
    end
  end
end
