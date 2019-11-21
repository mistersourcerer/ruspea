module Ruspea::Interpreter::Matchers
  class Comment
    def initialize
      @line_matcher = Line.new
    end

    def match?(code)
      code[0] == ";"
    end

    def read(code, position = Position::INITIAL, comment = "", started: false)
      remaining =
        if code[0] == ";" && !started
          started = true
          code[1..code.length]
        else
          code
        end

      new_position = position
      new_line = @line_matcher.match?(remaining)
      finished = new_line || code.length == 0

      if finished
        if new_line
          _, remaining, new_position = @line_matcher.read(remaining, new_position)
        end

        return [
          Ruspea::Interpreter::Forms::Comment.new(comment, position),
          remaining,
          new_position
        ]
      end

      read(
        remaining[1..remaining.length],
        position,
        comment + remaining[0],
        started: started)
    end
  end
end
