module Ruspea
  class Reader::Matchers::Numeric
    def match?(code)
      code[0] == "-" && DIGIT.match?(code[1]) || DIGIT.match?(code[0])
    end

    def read(code, position = Position::INITIAL, number = "")
      number, rest = read_digit(code, number)

      value, remaining, type =
        if float?(rest)
          read_digit(rest[1..rest.length], number + ".") + [
            Ruspea::Forms::Float
          ]
        else
          [number, rest, Ruspea::Forms::Integer]
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

    def float?(code)
      code[0] == "." && match?(code[1..code.length])
    end
  end
end
