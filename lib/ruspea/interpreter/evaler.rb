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
      @core = Ruspea::Runtime::Env.new
      pos = Ruspea::Interpreter::Position.new(0, 0)

      CORE.each { |name, fn|
        @core[Ruspea::Forms::Symbol.new(name, pos)] = fn
      }
    end

    def call(form, context = nil)
      exec_context =
        if !context.nil?
          Ruspea::Runtime::Env.new(context.fallback(@core))
        else
          Ruspea::Runtime::Env.new(@core)
        end

      form.eval(exec_context)
    end

    private

    attr_reader :reader
  end
end
