module Ruspea::Interpreter
  module Form
    attr_reader :value, :position

    def self.included(target)
      def target.match?(_)
        raise "missing .match? on #{self}"
      end

      def target.read(_, _)
        raise "missing .read on #{self}"
      end
    end

    def initialize(value, position = Position::INITIAL)
      @value = cast(value)
      @position = position
    end

    def cast(string)
      string
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
