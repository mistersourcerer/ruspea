module Ruspea::Evaler
  RSpec.describe Eval do
    let(:builder) { Ruspea::Runtime::List }
    subject(:evaler) { described_class.new }

    def sym(string)
      Ruspea::Runtime::Sym.new string
    end

    context "function calls" do
      it "knows how to (quote symbols)" do
        invocation = builder.create sym("quote"), sym("symbols")

        expect(evaler.call(invocation)).to eq sym("symbols")
      end
    end
  end
end
