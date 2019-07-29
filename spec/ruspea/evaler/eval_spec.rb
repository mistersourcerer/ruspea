module Ruspea::Evaler
  RSpec.describe Eval do
    let(:builder) { Ruspea::Runtime::List }
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

  end
end
