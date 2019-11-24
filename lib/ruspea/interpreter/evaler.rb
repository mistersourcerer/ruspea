module Ruspea::Interpreter
  class Evaler
    CORE = {
      #"atom?" => Ruspea::Core::Atom.new,
      "quote" => Ruspea::Core::Quote.new,
      # "car"   => CAR = Ruspea::Core::Car.new,
      # "head"  => CAR,
      # "first" => CAR,
    }

    def initialize
      @reader = Reader.new

      @core = Ruspea::Runtime::Env.new
      pos = Ruspea::Interpreter::Position.new(0, 0)

      CORE.each { |name, fn|
        @core[Ruspea::Forms::Symbol.new(name, pos)] = fn
      }
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
