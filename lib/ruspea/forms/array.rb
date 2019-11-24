module Ruspea::Forms
  class Array
    include Ruspea::Form

    def inspect
      values = self.value.map { |value|
        "  #{value.inspect}"
      }.join("\n")
      "(%_form [\n#{values} ]\n  #{self.position.inspect}\n  \"#{self.class.name}\")"
    end
  end
end
