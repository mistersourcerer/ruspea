module Ruspea::Runtime
  RSpec.describe Lmbd do
    let(:sym) { Sym }
    let(:noop) { ->(_){ } }

    describe ".new" do
      it "maps accepted arguments to arity" do
        lmbd = Lmbd.new(params: [sym.new(:lhs), sym.new(:rhs)], body: noop)
        lmbd_no_params = Lmbd.new(body: noop)

        expect(lmbd.arity).to eq 2
        expect(lmbd_no_params.arity).to eq 0
      end

      it "raises if no body is given" do
        expect { Lmbd.new }
          .to raise_error "All lambdas need a body! Maybe body: ->{}?"
      end
    end

    describe "#call" do
      it "calls the underneath body" do
        block = Lmbd.new { 1 }
        body = Lmbd.new(body: ->(_){ 1 })

        expect(block.call).to eq 1
        expect(body.call).to eq 1
      end

      it "ignores body parameter when a block is given" do
        body = Lmbd.new(body: ->{ 1 }) { 2 }

        expect(body.call).to eq 2
      end

      it "creates an Env with the arguments bound to the params" do
        body = Lmbd.new(params: [sym.new(:lhs), sym.new(:rhs)]) { |env|
          [ env[sym.new(:lhs)], env[sym.new(:rhs)] ]
        }

        expect(body.call(1, 2)).to eq [1, 2]
      end

      it "raises if arguments don't match the original arity" do
        body = Lmbd.new(
          params: [sym.new(:lhs), sym.new(:rhs)],
          body: noop)
        way_less = Lmbd.new(
          params: [sym.new(:lhs), sym.new(:rhs), sym.new(:lol)],
          body: noop)

        expect { body.call }.to raise_error(
          Ruspea::Error::Arity, "Expected 2 args, but received 0")
        expect { way_less.call }.to raise_error(
          Ruspea::Error::Arity)
      end
    end
  end
end