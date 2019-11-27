module Ruspea
  class Forms::Map
    include Ruspea::Form

    def eval(context)
      @evaler ||= Evaler.new

      self.value
        .map { |sym, value| [sym.value, @evaler.call(value, context)] }
        .to_h
        .then { |hash| Runtime::Map.new(hash) }
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
          other.value.values == self.value.values

        return true
      end

      false
    end
  end
end
