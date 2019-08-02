module Ruspea::Runtime
  RSpec.describe Fn do
    describe "#call" do
      it "evaluates the body and returns the last statement" do
        expect(Fn.new([3, 2, 1]).call).to eq 1
      end

      it "binds the arguments to the previously defined parameters" do
        fn = Fn.new([Sym.new("wow")], params: [Sym.new("wow")])

        expect(fn.call(4.20)).to eq 4.20
      end

      it "finds external symbols via the context" do
        ctx = Env.new.tap { |e| e.define Sym.new("lol"), 4.20 }
        fn = Fn.new([Sym.new("lol")], context: ctx)

        expect(fn.call).to eq 4.20
      end
    end

    describe "#eql?" do
      it "returns true for two functions with same body and params" do
        expect(Fn.new).to eq Fn.new
        expect(Fn.new([1])).to eq Fn.new([1])
        expect(
          Fn.new(params: [Sym.new("wow")])
        ).to eq Fn.new(params: [Sym.new("wow")])
        expect(
          Fn.new([1], params: [Sym.new("wow")])
        ).to eq Fn.new([1], params: [Sym.new("wow")])
        expect(
          Fn.new([1], params: [Sym.new("wow")], context: Env.new)
        ).to eq Fn.new([1], params: [Sym.new("wow")], context: Env.new)

        expect(Fn.new([1])).to_not eq Fn.new([2])
        expect(
          Fn.new(params: [Sym.new("wow")])
        ).to_not eq Fn.new(params: [Sym.new("bbq")])
        expect(
          Fn.new([1], params: [Sym.new("zaz")])
        ).to_not eq Fn.new([2], params: [Sym.new("zaz")])
        expect(
          Fn.new([1], params: [Sym.new("zaz")])
        ).to_not eq Fn.new([1], params: [Sym.new("lol")])
      end
    end
  end
end
