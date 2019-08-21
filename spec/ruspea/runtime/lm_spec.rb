module Ruspea::Runtime
  RSpec.describe Lm do
    subject(:lm) { described_class }

    context "body execution" do
      it "returns the value of the last expression in the body" do
        fn = lm.new body: ["hello", "world"]

        expect(fn.call).to eq "world"
      end

      it "delegates evaluation of body expressions to evaler" do
        evaler = spy("evaler")
        fn = lm.new(body: [Sym.new("number")])

        fn.call(evaler: evaler)

        expect(evaler).to have_received(:call).with(Sym.new("number"), context: instance_of(Env))
      end

      it "calls body with environment, context and evaler if body is a #call" do
        evaler = spy("evaler")
        body = spy("body with #call")
        fn = lm.new(
          params: [Sym.new("time"), Sym.new("over")],
          body: body,)
        ctx = Env.new.tap { |e| e.define Sym.new("external"), "context" }

        fn.call(420, 9000, context: ctx, evaler: evaler)

        expected_env = Env.new(ctx).tap { |e|
          e.define Sym.new("time"), 420
          e.define Sym.new("over"), 9000
          e.define Sym.new("%ctx"), ctx
        }
        expect(body).to have_received(:call).with(expected_env, evaler)
      end
    end

    context "environment binding" do
      it "creates an environment for the evaluator with correct symbol > val" do
        evaler = instance_double(Ruspea::Interpreter::Evaler)

        fn = lm.new(
          params: [Sym.new("name")],
          body: [1],)

        # Evaluates argument in the caller context
        allow(evaler).to receive(:call)
          .with("Friedman", context: Env::Empty.instance)
          .and_return("Friedman")

        env = Env.new.tap { |env|
          env.define Sym.new("name"), "Friedman"
          env.define Sym.new("%ctx"), Env::Empty.instance
        }

        # Then evaluates the body with passing the correct context
        expect(evaler).to receive(:call).with(1, context: env)

        fn.call("Friedman", evaler: evaler)
      end

      it "keeps the caller context within it's environment" do
        evaler = instance_double(Ruspea::Interpreter::Evaler)
        fn = lm.new(params: [Sym.new("name")], body: [1])
        caller_context = Env.new.tap { |e| e.define Sym.new("number"), 420 }

        # Evaluates argument in the caller context
        allow(evaler).to receive(:call)
          .with("Friedman", context: caller_context)
          .and_return("Friedman")

        env = Env.new(caller_context).tap { |env|
          env.define Sym.new("name"), "Friedman"
          env.define Sym.new("%ctx"), caller_context
        }

        # Then evaluates the body with passing the correct context
        expect(evaler).to receive(:call).with(1, context: env)

        fn.call("Friedman", context: caller_context, evaler: evaler)
      end
    end

    context "arity handling" do
      it "raises error when reciving wrong arity arguments" do
        fn = lm.new(params: [Sym.new("one"), Sym.new("two")])

        expect { fn.call }.to raise_error(
          Ruspea::Error::Arity, "Expected 2 args, but received 0")
        expect { fn.call(1, 2, 3) }.to raise_error(
          Ruspea::Error::Arity, "Expected 2 args, but received 3")
      end
    end

    context "closures" do
      it "remembers symbols from when the functions was created" do
        # This means that the caller context for the fn creation
        # is the fallback for the function environment.
        closured_env = Env.new.tap { |env|
          # this symbol will be called in te body,
          # but is overriden by the parameter in the call
          env.define Sym.new("overriden_by_param"), 100

          # this will be used in the body as it is
          env.define Sym.new("dragged_into_closure"), 418
        }

        fn = lm.new(
          params: [Sym.new("overriden_by_param")],
          body: ->(env, evaler) {
            1 +
            env.lookup(Sym.new("overriden_by_param")) +
            env.lookup(Sym.new("dragged_into_closure"))
          },
          closure: closured_env
        )

        expect(fn.call(1)).to eq 420
      end

      it "remembers symbols from when the functions was created in a evaluated body" do
        closured_env = Env.new.tap { |env|
          env.define Sym.new("dragged_into_closure"), 420
        }

        fn = lm.new(
          body: [
            Sym.new("dragged_into_closure")
          ],
          closure: closured_env
        )

        expect(fn.call(evaler: Ruspea::Interpreter::Evaler.new)).to eq 420
      end

      it "overrides closures with parameters" do
        closured_env = Env.new.tap { |env|
          env.define Sym.new("overriden"), 420
        }

        fn = lm.new(
          params: [Sym.new("overriden")],
          body: [
            Sym.new("overriden")
          ],
          closure: closured_env
        )

        evaler = Ruspea::Interpreter::Evaler.new
        expect(fn.call("not yet", evaler: evaler)).to eq "not yet"
      end
    end
  end
end
