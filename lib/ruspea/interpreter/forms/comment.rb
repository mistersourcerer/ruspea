module Ruspea::Interpreter::Forms
  class Comment
    include Ruspea::Interpreter::Form

    class << self
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
        new_line = Line.match?(remaining)
        finished = new_line || code.length == 0

        if finished
          if new_line
            _, remaining, new_position = Line.read(remaining, new_position)
          end

          return [new(comment, position), remaining, new_position]
        end

        read(
          remaining[1..remaining.length],
          position,
          comment + remaining[0],
          started: started)
      end
    end

    def inspect
      "(%_form \"#{self.value}\" #{self.position.inspect} \"#{self.class.name}\")"
    end
  end
end
