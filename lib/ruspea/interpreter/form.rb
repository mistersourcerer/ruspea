module Ruspea::Interpreter
  class Form
    attr_reader :value, :meta, :evaler

    def initialize(value, evaler: nil, closed: true)
      @value = value
      @meta = meta
      @evaler = evaler
    end

    def eval(context, main_evaler)
      @evaler.call(self.value, context, main_evaler)
    end

    def eq?(other)
      self == other
    end

    def eql?(other)
      self == other
    end

    def ==(other)
      return false if self.class != other.class
      value == other.value && meta == other.meta
    end

    def inspect
      "Form< #{value.inspect} >"
    end
  end
end
