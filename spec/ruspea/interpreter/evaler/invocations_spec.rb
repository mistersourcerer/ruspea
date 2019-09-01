module Ruspea::Interpreter
  RSpec.describe Evaler, "Invocations" do
    subject(:evaler) { described_class.new }
    let(:env) { Ruspea::Runtime::Env.new(Ruspea::Language::Core.new) }
    let(:reader) { Reader.new }
    let(:sym) { Ruspea::Runtime::Sym }
    let(:lm) { Ruspea::Runtime::Lm }
    let(:list) { Ruspea::Runtime::List }

    it "treats Lists as function invocation" do
      _, forms = reader.call("(def callable (fn [] 420))\n(callable)")
      result = evaler.call forms, context: env
      expect(result.last).to eq 420
    end

    it "raises if no function with the given name is found" do
      _, forms = reader.call("(no)")

      expect {
        evaler.call(forms)
      }.to raise_error Ruspea::Error::Resolution
    end

    it "raises if list.head ! respond_to? :call"

    it "evaluates the parameters before calling the function" do
      _, forms = reader.call("(def number 420)")

      expect(
        evaler.call(
          forms.last, context: env)).to eq 420
      expect(
        env.call(
          sym.new("number"))).to eq 420

      _, forms = reader.call("(def new_number number)")

      expect(
        evaler.call(
          forms.last, context: env)).to eq 420
    end

    it "evaluates parameters before calling user functions" do
      _, forms = reader.call("(def number 420)")
      evaler.call(forms.first, context: env)

      declaration = "(def fun (fn [number_arg] number_arg))"
      _, forms = reader.call(declaration)
      evaler.call(forms.first, context: env)

      invocation = "(fun number)"
      _, forms = reader.call(invocation)
      expect(evaler.call(forms.first, context: env)).to eq 420

      invocation = "(fun 13)"
      _, forms = reader.call(invocation)
      expect(evaler.call(forms.first, context: env)).to eq 13
    end
  end
end
