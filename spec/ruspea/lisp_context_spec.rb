module Ruspea
  RSpec.describe "Evaluation within a lisp context" do
    let(:lisp) { Core::Scope.new.register_public Core::Lisp.new }
    let(:ctx) { Core::Context.new lisp }
    let(:evaler) { Evaler.new }

    describe "#eval" do
      it "finds the lisp function (quote) in the evaluation context" do
        result = evaler.eval(
          Core::List.create("quote", Core::Symbol.new("a")),
          ctx
        )
        expect(result).to eq Core::Symbol.new("a")
      end
    end
  end
end
