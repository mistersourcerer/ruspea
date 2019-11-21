module Ruspea::Interpreter::Matchers
  class Array < Collection["[", "]"]
    def read(code, position = Position::INITIAL)
      elements, remaining, new_position = read_collection(code, position)
      without_separators = elements.reject { |form|
        form.is_a?(Ruspea::Interpreter::Forms::Separator)
      }
      [
        Ruspea::Interpreter::Forms::Array.new(without_separators, position),
        remaining[1..remaining.length],
        new_position + 1
      ]
    end
  end
end
