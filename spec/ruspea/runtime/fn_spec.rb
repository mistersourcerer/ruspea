module Ruspea::Runtime
  RSpec.describe Fn do
    subject(:fn) { described_class.new }

    it "routes call to the right internal lambda given the arity" do
      fn.add(
        Lm.new(
          params: [Sym.new("one")],
          body: [1]))

      fn.add(
        Lm.new(
          params: [Sym.new("one"), Sym.new("two")],
          body: [2]))

      expect(fn.call("one")).to eq 1
      expect(fn.call("one", "two")).to eq 2
    end
  end
end
