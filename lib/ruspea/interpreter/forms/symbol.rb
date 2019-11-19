module Ruspea::Interpreter::Forms
  class Symbol
    include Ruspea::Interpreter::Form

    class << self
      def match?(code)
        return false if code.nil?

        !Separator.match?(code) && !DELIMITERS.match?(code[0])
      end

      def read(code, position = Position::INITIAL, current = "")
        finished = code.length == 0 || !match?(code)
        return final_form(code, current, position) if finished

        read(code[1..code.length], position, current + code[0])
      end

      private

      def final_form(code, current, position)
        form =
          if match = KEYWORD.match(current)
            Keyword.new(match[:keyword], position)
          else
            new(current, position)
          end

        [form, code, position + current.length]
      end

      KEYWORD = /\A:(?<keyword>.*)|(?<keyword>.*):\z/
      DELIMITERS = /\A(\[|\]|\{|\}|\(|\))/
    end
  end
end
