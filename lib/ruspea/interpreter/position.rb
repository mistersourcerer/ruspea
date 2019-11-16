module Ruspea::Interpreter
  class Position
    attr_reader :column, :line

    def initialize(column, line)
      @column = column
      @line = line
    end
    INITIAL = Position.new(0, 1)

    def +(new_position)
      if new_position.is_a?(Integer)
        return self.class.new(column + new_position, line)
      end

      invalid =
        !new_position.length == 2 ||
        new_position.any? { |pos| !pos.is_a?(Integer) }
      if invalid
        raise "Invalid new position #{new_position}, use Numeric or [0, 0]"
      end

      self.class.new(column + new_position[0], line + new_position[1])
    end

    def inspect
      "{column: #{self.column}, line: #{self.line}}"
    end

    def to_s
      inspect
    end

    def eql?(other)
      self == other
    end

    def ==(other)
      if other.is_a?(self.class) &&
          other.column == self.column &&
          other.line == self.line

        return true
      end

      false
    end
  end
end
