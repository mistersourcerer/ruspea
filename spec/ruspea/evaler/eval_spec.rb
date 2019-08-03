module Ruspea::Evaler
  RSpec.describe Eval do
    let(:builder) { Ruspea::Runtime::List }
    let(:env) { Ruspea::Runtime::Env }
    let(:fn) { Ruspea::Runtime::Fn }

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

      it "invokes user defined functions" do
        new_env = env.new
        new_env.define sym("lol"), fn.new([1])

        invocation = builder.create sym("lol")
        expect(evaler.call(invocation, env: new_env)).to eq 1
      end

      it "invokes user defined functions (when they are ruby lambdas too)" do
        new_env = env.new
        new_env.define sym("lol"), ->(list, _) { list.head }

        invocation = builder.create sym("lol"), 1
        expect(evaler.call(invocation, env: new_env)).to eq 1
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

    context "interop" do
      it "calls the underlying ruby method" do
        invocation = builder.create(
          sym("."),
          1,
          sym("+"),
          2
        )
        ruspea = Ruspea::Language::Rsp.new

        expect(evaler.call(invocation, env: ruspea)).to eq 3
      end

      it "creates ruby land objects" do
        invocation = builder.create(
          sym("."),
          sym("Array"),
          sym("new"),
        )
        ruspea = Ruspea::Language::Rsp.new

        expect(evaler.call(invocation, env: ruspea)).to eq []
      end
    end
  end
end
