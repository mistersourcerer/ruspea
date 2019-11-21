module Ruspea::Interpreter::Matchers
  class Numeric
    def match?(code)
      code[0] == "-" && DIGIT.match?(code[1]) || DIGIT.match?(code[0])
    end

    def read(code, position = Position::INITIAL, number = "")
      number, rest = read_digit(code, number)

      float = rest[0] == "." && match?(rest[1..rest.length])
      value, remaining =
        if float
          read_digit(rest[1..rest.length], number + ".")
        else
          [number, rest]
        end

      type =
        if float
          Ruspea::Interpreter::Forms::Float
        else
          Ruspea::Interpreter::Forms::Integer
        end

      [type.new(value, position), remaining, position + value.length]
    end

    private

    DIGIT = /\A\d/
    NUMERIC = /\A[\d_]/
    SEPARATOR = /\A[,\s]/

    def read_digit(code, number = "")
      return read_digit(code[1..code.length], "-") if negative?(code, number)
      return [number, code] if !match?(code)
      read_digit(code[1..code.length], number + code[0])
    end

    def negative?(code, number)
      number.length == 0 && code[0] == "-" && match?(code[1])
    end

    def finished?(code)
      char = code[0]
      code[1..code.length].length == 0 || SEPARATOR.match?(char)
    end
  end
end
