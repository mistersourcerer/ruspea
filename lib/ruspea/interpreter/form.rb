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

      def target.read_collection(code, position, close_delimiter = "]")
        reader = Ruspea::Interpreter::Reader.new
        new_position = position + 1
        remaining = code[1..code.length]
        elements = []

        while(remaining[0] != close_delimiter)
          if remaining.length == 0
            raise "Expected array starting on #{position} to be closed with ']'"
          end

          form, remaining, new_position = reader.next(remaining, new_position)
          elements = elements + [form]
        end

        [elements, remaining, new_position]
      end
    end

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
