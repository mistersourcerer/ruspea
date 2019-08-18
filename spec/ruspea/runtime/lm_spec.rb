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
        fn = lm.new(body: [1], evaler: evaler)

        fn.call

        expect(evaler).to have_received(:call).with(1, context: instance_of(Env))
      end

      it "calls body with environment, context and evaler if body is a #call" do
        evaler = spy("evaler")
        body = spy("body with #call")
        fn = lm.new(
          params: [Sym.new("time"), Sym.new("over")],
          body: body,
          evaler: evaler)
        ctx = Env.new.tap { |e| e.define Sym.new("external"), "context" }

        fn.call(420, 9000, context: ctx)

        expected_env = Env.new(ctx).tap { |e|
          e.define Sym.new("time"), 420
          e.define Sym.new("over"), 9000
          e.define Sym.new("%ctx"), ctx
        }
        expect(body).to have_received(:call).with(expected_env, ctx, evaler)
      end

      it "makes context available in the body (%ctx)"
    end

    context "environment binding" do
      it "creates an environment for the evaluator with correct symbol > val" do
        evaler = spy("evaler")
        fn = lm.new(
          params: [Sym.new("name")],
          body: [1],
          evaler: evaler)

        fn.call("Friedman")

        env = Env.new.tap { |env|
          env.define Sym.new("name"), "Friedman"
          env.define Sym.new("%ctx"), Env::Empty.instance
        }
        expect(evaler).to have_received(:call).with(1, context: env)
      end

      it "keeps the caller context within it's environment" do
        evaler = spy("Evaler")
        fn = lm.new(params: [Sym.new("name")], body: [1], evaler: evaler)
        caller_context = Env.new.tap { |e| e.define Sym.new("number"), 420 }

        fn.call("Friedman", context: caller_context)

        env = Env.new(caller_context).tap { |env|
          env.define Sym.new("name"), "Friedman"
          env.define Sym.new("%ctx"), caller_context
        }
        expect(evaler).to have_received(:call).with(1, context: env)
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
  end
end
