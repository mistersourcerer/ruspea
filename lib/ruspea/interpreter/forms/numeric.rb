module Ruspea::Interpreter::Forms
  class Numeric
    include Ruspea::Interpreter::Form

    class << self
      def match?(code)
        code[0] == "-" && DIGIT.match?(code[1]) || DIGIT.match?(code[0])
      end

      def read(code, position = Position::Initial, number = "")
        number, rest = read_digit(code, number)

        float = rest[0] == "." && match?(rest[1..rest.length])
        value, remaining =
          if float
            read_digit(rest[1..rest.length], number + ".")
          else
            [number, rest]
          end

        type = float ? Float : Integer
        [type.new(value, position), remaining]
      end

      private

      DIGIT = /\A\d/
      NUMERIC = /\A[\d_]/
      SEPARATOR = /\A[,\s]/

      def read_digit(code, number = "")
        negative = number.length == 0 &&
          code[0] == "-" &&
          Numeric.match?(code[1])
        return read_digit(code[1..code.length], "-") if negative

        return [number, code] if !Numeric.match?(code)

        char = code[0]
        remaining = code[1..code.length]
        finished = remaining.length == 0 || SEPARATOR.match?(char)
        return [number + char, remaining] if finished

        read_digit(remaining, number + char)
      end
    end
  end
end
