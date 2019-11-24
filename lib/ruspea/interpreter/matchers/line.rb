module Ruspea::Interpreter::Matchers
  class Line
    def match?(code)
      code && LINE.match?(code)
    end

    def read(code, position = Position::INITIAL, lines = 0)
      if match?(code)
        read(code[1..code.length], position, lines + 1)
      else
        [
          Ruspea::Forms::Line.new(lines, position),
          code,
          position << lines
        ]
      end
    end

    private

    LINE = /\A\n.*/
  end
end
