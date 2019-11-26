module Ruspea
  class Evaler
    CORE = {
      #"atom?" => Core::Atom.new,
      "quote" => Core::Quote.new,
      # "car"   => CAR = Core::Car.new,
      # "head"  => CAR,
      # "first" => CAR,
    }

    def initialize
      @core = Runtime::Env.new
      pos = Position.new(0, 0)

      CORE.each { |name, fn|
        @core[Forms::Symbol.new(name, pos)] = fn
      }
    end

    def call(form, context = nil)
      exec_context =
        if !context.nil?
          Runtime::Env.new(context.fallback(@core))
        else
          Runtime::Env.new(@core)
        end

      form.eval(exec_context)
    end

    private

    attr_reader :reader
  end
end
