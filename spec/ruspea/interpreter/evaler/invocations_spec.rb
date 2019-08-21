module Ruspea::Interpreter
  RSpec.describe Evaler, "Invocations" do
    include Ruspea::Runtime

    subject(:evaler) { described_class.new }

    it "treats Lists as function invocation" do
      fn_name = Ruspea::Runtime::Sym.new("fn")
      fn = Ruspea::Runtime::Lm.new body: [420]
      cxt = Ruspea::Runtime::Env.new.tap { |env| env.define fn_name, fn }

      list = Ruspea::Runtime::List.create fn_name

      result = evaler.call list, context: cxt
      expect(result).to eq 420
    end

    it "raises if no function with the given name is found" do
      list = Ruspea::Runtime::List.create Ruspea::Runtime::Sym.new("no")

      expect {
        evaler.call(list)
      }.to raise_error Ruspea::Error::Resolution
    end

    it "raises if list.head ! respond_to? :call"

    it "evaluates the parameters before calling the function" do
      list = Ruspea::Runtime::List
      sym = Ruspea::Runtime::Sym
      env = Ruspea::Runtime::Env.new(Ruspea::Language::Core.new)

      # (def number 420)
      attribution = list.create(
        sym.new("def"),
        sym.new("number"),
        420
      )
      expect(
        evaler.call(
          attribution, context: env)).to eq 420
      expect(
        env.call(
          sym.new("number"))).to eq 420

      # (def new_number number)
      new_attribution = list.create(
        sym.new("def"),
        sym.new("new_number"),
        sym.new("number")
      )
      expect(
        evaler.call(
          new_attribution, context: env)).to eq 420
    end

    it "evaluates parameters before calling user functions" do
      # (defn fn [number_arg] number_arg)
      fn_name = Ruspea::Runtime::Sym.new("fn")
      number = Ruspea::Runtime::Sym.new("number")

      fn = Ruspea::Runtime::Lm.new(
        params: [Ruspea::Runtime::Sym.new("number_arg")],
        body: [Ruspea::Runtime::Sym.new("number_arg")],
      )

      ctx = Ruspea::Runtime::Env.new.tap { |env|
        env.define fn_name, fn
        env.define number, 420
      }

      list = Ruspea::Runtime::List.create(
        fn_name,
        Ruspea::Runtime::Sym.new("number")
      )

      # (fn number) => 420
      expect(evaler.call(list, context: ctx)).to eq 420

      # (fn 13) => 13
      list_with_13 = Ruspea::Runtime::List.create(fn_name, 13)
      expect(evaler.call(list_with_13, context: ctx)).to eq 13
    end
  end
end
