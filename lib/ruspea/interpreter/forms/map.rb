module Ruspea::Interpreter::Forms
  class Map
    include Ruspea::Interpreter::Form

    class << self
      def match?(code)
        code[0] == "{"
      end

      def read(code, position = Position::INITIAL)
        elements, remaining, new_position =
          read_collection(code, position, close_delimiter = "}")
        without_separator = elements.reject { |form| form.is_a?(Separator) }
        hsh = Hash[without_separator.each_slice(2).to_a]
        [new(hsh, position), remaining[1..remaining.length], new_position + 1]
      end
    end

    def inspect
      values = self.value.map { |k, value|
        "#{k.value}: #{value.value}"
      }.join("\n")
      "(%_form {#{values}}\n  #{self.position.inspect}\n  \"#{self.class.name}\")"
    end

    def ==(other)
      if other.is_a?(self.class) &&
          # The pure hash comparison wasn't working on me.
          # Something is weird... =/
          other.value.keys == self.value.keys &&
          other.value.values == self.value.values &&
          other.position == self.position

        return true
      end

      false
    end
  end
end
