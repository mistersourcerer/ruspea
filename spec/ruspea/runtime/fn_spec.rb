module Ruspea::Runtime
  RSpec.describe Fn do
    subject(:fn) { described_class.new }
    let(:form) { Ruspea::Interpreter::Form }

    it "routes calls to the right internal lambda given the arity" do
      fn.add(
        Lmbd.new(
          params: [Sym.new("one")],
          body: ->(_){ 1 }))

      fn.add(
        Lmbd.new(
          params: [Sym.new("one"), Sym.new("two")],
          body: ->(_) { 2 }))

      expect(fn.call(form.new("one"))).to eq 1
      expect(fn.call(form.new("one"), form.new("two"))).to eq 2
    end

    it "raises when the argument number doesn't match any arity in the fn"
    # Should respond_to? :arities, so we can build the message:
    # Error::ArityMismatch: available arities are fn/1, fn/2, fn/4
  end
end
