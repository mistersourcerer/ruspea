module Ruspea
  RSpec.describe Lisp::Cond do
    include Core::Casting

    let(:env) { Core::Environment.new }
    subject(:cond) { described_class.new }

    describe "#call" do
      it "raises if parameter is not a list" do
        expect { cond.call(1, env) }.to raise_error(
          Error::Execution,
          /Argument should be a list, received 1 instead/
        )
      end

      it "raises if a clause list is empty" do
        expect { cond.call(List(List(false, 1), 1), env) }.to raise_error(
          Error::Execution,
          /A non-list clause was found in position: 2/
        )
      end

      it "evaluates all expressions on a list if first element is truthy" do
        env["eq"] = Lisp::Eq.new

        expect(cond.call(List(List(true, 1, 2), List(true, 2)), env)).to eq 2
        expect(cond.call(List(List(false, 1), List(1, 420)), env)).to eq 420
        expect(
          cond.call(
            List(
              List(false, 1),
              List(Symbol("eq"), 1, 1, 420),
            ), env
          )
        ).to eq 420
      end

      it "returns nil if there is no list with truthy first element" do
        expect(cond.call(List(List(false), List(false)), env)).to eq nil
      end
    end
  end
end
