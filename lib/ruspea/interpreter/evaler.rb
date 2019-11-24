module Ruspea::Interpreter
  class Evaler
    def initialize
      @reader = Reader.new
      @core = Ruspea::Runtime::Env.new
      pos = Ruspea::Interpreter::Position.new(0, 0)
      sym = Ruspea::Forms::Symbol.new("atom?", pos)
      @core[sym] = Ruspea::Core::Atom.new
    end

    def call(code)
      context = Ruspea::Runtime::Env.new(@core)
      form, remaining, _ = reader.next(code)
      forms = [form]

      while(!remaining.nil? && remaining.length > 0)
        form, remaining, _ = reader.next(code)
        forms << form
      end

      forms.map { |form| form.eval(context) }
    end

    private

    attr_reader :reader
  end
end
