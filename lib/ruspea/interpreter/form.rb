module Ruspea::Interpreter
  class Form
    attr_reader :value, :meta

    def initialize(value, meta = {closed: true})
      @value = value
      @meta = meta
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
      "Form(#{value.inspect})"
    end
  end
end
