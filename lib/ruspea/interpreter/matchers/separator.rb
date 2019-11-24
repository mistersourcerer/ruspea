module Ruspea::Interpreter::Matchers
  class Separator
    def match?(code)
      code && SEPARATOR.match?(code[0])
    end

    def read(code, position = Position::INITIAL, separators = "")
      if !match?(code)
        return [
          Ruspea::Forms::Separator.new(separators, position),
          code,
          position + separators.length
        ]
      end

      remaining = code[1..code.length]
      read(remaining, position, separators + code[0])
    end

    private

    SEPARATOR = /\A[,\s]/
  end
end
