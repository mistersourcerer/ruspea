module Ruspea::Interpreter::Forms
  class Array
    include Ruspea::Interpreter::Form

    class << self
      def match?(code)
        code[0] == "["
      end

      def read(code, position = Position::INITIAL)
        elements, remaining, new_position =
          read_collection(code, position, "]")
        without_separators = elements.reject { |form| form.is_a?(Separator) }
        [
          new(without_separators, position),
          remaining[1..remaining.length],
          new_position + 1]
      end
    end

    def inspect
      values = self.value.map { |value|
        "  #{value.inspect}"
      }.join("\n")
      "(%_form [\n#{values} ]\n  #{self.position.inspect} \"#{self.class.name}\")"
    end
  end
end
