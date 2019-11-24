module Ruspea::Interpreter
  RSpec.describe Evaler do
    subject(:evaler) { described_class.new }

    describe "Atoms" do
      it "evaluates numbers" do
        expect(evaler.call("1")).to eq [1]
      end

      it "evalutes strings" do
        expect(evaler.call("\"ruspea\"")).to eq ["ruspea"]
      end

      it "evaluates keywords" do
        expect(evaler.call(":a")).to eq [:a]
        expect(evaler.call("a:")).to eq [:a]
      end
    end

    describe "(core) Functions" do
      describe "atom?" do
        it "returns true for numbers, strings and keywords" do
          expect(evaler.call("(atom? 1)")).to eq [true]
          expect(evaler.call("(atom? \"ruspea\")")).to eq [true]
          expect(evaler.call("(atom? :a)")).to eq [true]
        end
      end
    end
  end
end
