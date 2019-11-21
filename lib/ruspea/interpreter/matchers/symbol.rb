module Ruspea::Interpreter::Matchers
  class Symbol
    def match?(code)
      return false if code.nil?

      !SEPARATOR.match?(code) && !DELIMITERS.match?(code[0])
    end

    def read(code, position = Position::INITIAL, current = "")
      finished = code.length == 0 || !match?(code)
      return final_form(code, current, position) if finished

      read(code[1..code.length], position, current + code[0])
    end

    private

    KEYWORD = /\A:(?<keyword>.*)|(?<keyword>.*):\z/
    DELIMITERS = /\A(\[|\]|\{|\}|\(|\))/
    SEPARATOR = Separator.new

    def final_form(code, current, position)
      form =
        if match = KEYWORD.match(current)
          Ruspea::Interpreter::Forms::Keyword.new(match[:keyword], position)
        else
          Ruspea::Interpreter::Forms::Symbol.new(current, position)
        end

      [form, code, position + current.length]
    end
  end
end
