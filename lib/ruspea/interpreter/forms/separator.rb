module Ruspea::Interpreter::Forms
  class Separator
    include Ruspea::Interpreter::Form

    class << self
      def match?(code)
        code && SEPARATOR.match?(code[0])
      end

      def read(code, position = Position::INITIAL, separators = "")
        if !match?(code)
          return [new(separators, position), code, position + separators.length]
        end

        remaining = code[1..code.length]
        read(remaining, position, separators + code[0])
      end

      private

      SEPARATOR = /\A[,\s]/
    end
  end
end
