module Ruspea::Interpreter::Forms
  class Line
    include Ruspea::Interpreter::Form

    class << self
      def match?(code)
        code && LINE.match?(code)
      end

      def read(code, position = Position::INITIAL, lines = 0)
        if !match?(code)
          return [new(lines, position), code, position << lines]
        end

        read(code[1..code.length], position, lines + 1)
      end

      private

      LINE = /\A\n.*/
    end
  end
end
