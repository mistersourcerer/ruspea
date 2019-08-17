module Ruspea::Runtime
  RSpec.describe Lm do
    subject(:lm) { described_class }

    context "body execution" do
      it "returns the value of the last expression in the body" do
        fn = lm.new body: ["hello", "world"]

        expect(fn.call).to eq "world"
      end

      it "delegates evaluation of body expressions to evaler" do
        evaler = spy("Evaler")
        fn = lm.new(body: [1], evaler: evaler)

        fn.call

        expect(evaler).to have_received(:call).with(1, context: instance_of(Env))
      end
    end

    context "environment binding" do
      it "creates an environment for the evaluator with correct symbol > val" do
        evaler = spy("Evaler")
        fn = lm.new(
          params: [Sym.new("name")],
          body: [1],
          evaler: evaler)

        fn.call("Friedman")

        env = Env.new.tap { |env| env.define Sym.new("name"), "Friedman" }
        expect(evaler).to have_received(:call).with(1, context: env)
      end

      it "keeps the caller context within it's environment" do
        evaler = spy("Evaler")
        fn = lm.new(params: [Sym.new("name")], body: [1], evaler: evaler)
        caller_context = Env.new.tap { |e| e.define Sym.new("number"), 420 }

        fn.call("Friedman", context: caller_context)

        env = Env.new(caller_context).tap { |env|
          env.define Sym.new("name"), "Friedman"
        }
        expect(evaler).to have_received(:call).with(1, context: env)
      end
    end

    context "arity handling" do
      it "raises error when reciving wrong arity arguments"
    end
  end
end
