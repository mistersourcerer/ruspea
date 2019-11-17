module Ruspea::Interpreter::Forms
  class Symbol
    include Ruspea::Interpreter::Form

    class << self
      def match?(code)
        !Separator.match?(code)
      end

      def read(code, position = Position::INITIAL, current = "")
        char = code[0]
        remaining = code[1..code.length]

        if !match?(remaining)
          string = current + char
          form =
            if match = KEYWORD.match(string)
              Keyword.new(match[:keyword], position)
            else
              new(string, position)
            end

          return [form, remaining, position + string.length]
        end

        read(remaining, position, current + char)
      end

      private

      KEYWORD = /\A:(?<keyword>.*)|(?<keyword>.*):\z/
    end
  end
end
