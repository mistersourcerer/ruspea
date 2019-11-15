module Ruspea::Interpreter
  class Position
    attr_reader :column, :line

    def initialize(column, line)
      @column = column
      @line = line
    end
    INITIAL = Position.new(0, 1)

    def inspect
      "[#{self.column}, #{self.line}]"
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
