module Ruspea::Runtime
  RSpec.describe Fn do
    subject(:fn) { described_class.new }
    let(:form) { Ruspea::Interpreter::Form }

    it "routes call to the right internal lambda given the arity" do
      fn.add(
        Lm.new(
          params: [Sym.new("one")],
          body: List.create(form.new(1))))

      fn.add(
        Lm.new(
          params: [Sym.new("one"), Sym.new("two")],
          body: List.create(form.new(2))))

      expect(fn.call(form.new("one"))).to eq 1
      expect(fn.call(form.new("one"), form.new("two"))).to eq 2
    end
  end
end
