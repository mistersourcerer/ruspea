module Ruspea::Interpreter::Matchers
  class Comment
    def match?(code)
      code[0] == ";"
    end

    def read(code, position = Position::INITIAL, comment = "", started: false)
      remaining = remaining_comment(code, started)

      return create_form(remaining, position, comment) if finished?(remaining)

      read(
        remaining[1..remaining.length],
        position,
        comment + remaining[0],
        started: true
      )
    end

    private

    LINE = Line.new

    def new_line?(code)
      LINE.match?(code)
    end

    def finished?(code)
      new_line?(code) || code.length == 0
    end

    def final_position(code, position)
      if new_line?(code)
        _, remaining, new_position = LINE.read(code, position)
        [remaining, new_position]
      else
        [code, position]
      end
    end

    def create_form(code, position, comment)
      remaining, new_position = final_position(code, position)

      return [
        Ruspea::Forms::Comment.new(comment, position),
        remaining,
        new_position
      ]
    end

    def remaining_comment(code, started)
      if code[0] == ";" && !started
        started = true
        code[1..code.length]
      else
        code
      end
    end
  end
end
