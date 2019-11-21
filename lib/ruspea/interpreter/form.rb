module Ruspea::Interpreter
  module Form
    attr_reader :value, :position

    def initialize(value, position = Position::INITIAL)
      @value = cast(value)
      @position = position
    end

    def cast(value)
      value
    end

    def inspect
      "(%_form #{self.value} #{self.position.inspect} \"#{self.class.name}\")"
    end

    def eql?(other)
      self == other
    end

    def ==(other)
      if other.is_a?(self.class) &&
          other.value == self.value &&
          other.position == self.position

        return true
      end

      false
    end
  end
end
