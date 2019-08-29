module Ruspea::Interpreter
  RSpec.describe Evaler, "Invocations" do
    subject(:evaler) { described_class.new }
    let(:reader) { Reader.new }
    let(:sym) { Ruspea::Runtime::Sym }

    it "treats Lists as function invocation" do
      fn_name = Ruspea::Runtime::Sym.new("fn")
      fn = Ruspea::Runtime::Lm.new body: Ruspea::Runtime::List.new(Form.new(420))
      cxt = Ruspea::Runtime::Env.new.tap { |env| env.define fn_name, fn }

      list = Form.new(Ruspea::Runtime::List.create(Form.new(fn_name)))

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
      ctx = Ruspea::Runtime::Env.new(Ruspea::Language::Core.new).tap { |env|
        env.define sym.new("number"), 420
      }

      declaration = "(def fun (fn [number_arg] number_arg))"
      _, forms = reader.call(declaration)
      evaler.call(forms.first, context: ctx)

      invocation = "(fun number)"
      _, forms = reader.call(invocation)
      expect(evaler.call(forms.first, context: ctx)).to eq 420

      invocation = "(fun 13)"
      _, forms = reader.call(invocation)
      expect(evaler.call(forms.first, context: ctx)).to eq 13
    end
  end
end
