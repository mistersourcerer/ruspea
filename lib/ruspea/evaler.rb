module Ruspea
  class Evaler
    CORE = {
      "quote" => Core::Quote.new,
      "atom?" => Core::Atom.new,
      "eq?"   => Core::Eq.new,
      "first" => FIRST = Core::First.new,
      "head"  => FIRST,
      "rest"  => REST = Core::Rest.new,
      "tail"  => REST,
      "cons"  => Core::Cons.new,
    }

    def initialize
      @core = Runtime::Env.new
      pos = Position.new(0, 0)

      CORE.each { |name, fn|
        @core[Forms::Symbol.new(name, pos)] = fn
      }
    end

    def call(form, context = nil)
      fallback =
        if !context.nil?
          context.fallback(@core)
        else
          @core
        end

      form.eval Runtime::Env.new(fallback)
    end

    private

    attr_reader :reader
  end
end
