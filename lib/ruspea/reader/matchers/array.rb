module Ruspea
  class Reader::Matchers::Array < Reader::Matchers::Collection["[", "]"]
    def read(code, position = Position::INITIAL)
      forms, remaining, new_position = read_collection(code, position) { |form|
        !form.is_a?(Ruspea::Forms::Separator)
      }

      [
        Ruspea::Forms::Array.new(forms, position),
        remaining[1..remaining.length],
        new_position + 1
      ]
    end
  end
end
