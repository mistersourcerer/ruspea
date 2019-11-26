module Ruspea
  module Form
    attr_reader :value, :position

    def initialize(value, position = Position::INITIAL)
      @value = cast(value)
      @position = position
    end

    def eval(context)
      value
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
          other.value == self.value

        return true
      end

      false
    end

    def hash
      value.hash
    end
  end
end
