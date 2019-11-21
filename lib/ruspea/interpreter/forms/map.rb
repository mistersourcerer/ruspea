module Ruspea::Interpreter::Forms
  class Map
    include Ruspea::Interpreter::Form

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
