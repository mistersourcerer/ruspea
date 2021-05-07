module Ruspea::Core
  class Symbol
    attr_reader :label

    def initialize(label)
      @label = String(label)
    end

    def ==(other)
      return false if self.class != other.class
      label == other.label
    end

    alias eql? ==

    def hash
      label.hash
    end

    def to_s
      label
    end

    def inspect
      "'#{label}"
    end
  end
end
