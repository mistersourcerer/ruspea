module Ruspea
  RSpec.describe Core::Callable do
    def list(*args)
      Core::List.create(*args)
    end

    def sym(label)
      Core::Symbol.new(label)
    end

    let(:lisp) { Core::Scope.new.register_public Core::Lisp.new }
    let(:ctx) { Core::Context.new lisp }
    let(:evaler_blk) { ->(expr, own_ctx) { evaler.eval(expr, own_ctx || ctx) } }
    subject(:evaler) { Evaler.new }

    subject(:fun) {
      described_class.new(
        [sym("a"), sym("b")],
        list(),
        ctx,
        evaler_blk
      )
    }

    describe "#call" do
      it "raises if called with wrong arity" do
        expect { fun.call }.to raise_error Error::Execution
      end

      it "binds the parameters correctly" do
        val_for_a = nil
        val_for_b = nil
        fun.call(4, 20) { |_, own_ctx|
          val_for_a = own_ctx["a"]
          val_for_b = own_ctx["b"]
        }
        fun.call(4, 20)

        expect(val_for_a).to eq 4
        expect(val_for_b).to eq 20
      end

      it "ensures that external context is not polluted" do
        fun.call(4, 20)

        expect(ctx.defined?("a")).to eq false
        expect(ctx.defined?("b")).to eq false
      end

      it "evaluates the arguments before binding them in the ivk ctx" do
        ctx["banana"] = "terracota"
        ctx["platanos"] = "daterra"
        val_for_a = nil
        val_for_b = nil
        fun.call(sym("banana"), sym("platanos")) { |_, own_ctx|
          val_for_a = own_ctx["a"]
          val_for_b = own_ctx["b"]
        }

        expect(val_for_a).to eq "terracota"
        expect(val_for_b).to eq "daterra"
      end
    end
  end
end
