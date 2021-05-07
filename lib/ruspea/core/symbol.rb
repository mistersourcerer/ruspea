module Ruspea::Core
  class Symbol
    attr_reader :label

    def initialize(label)
      @label = String(label)
    end

    def to_s
      label
    end

    def eq?(other)
      self == other
    end

    def eql?(other)
      self == other
    end

    def ==(other)
      return false if self.class != other.class
      label == other.label
    end

    def hash
      label.hash
    end

    def inspect
      "'#{label}"
    end
  end
end
