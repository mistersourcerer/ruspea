module Ruspea::Interpreter::Forms
  class Array
    include Ruspea::Interpreter::Form

    def inspect
      values = self.value.map { |value|
        "  #{value.inspect}"
      }.join("\n")
      "(%_form [\n#{values} ]\n  #{self.position.inspect}\n  \"#{self.class.name}\")"
    end
  end
end
