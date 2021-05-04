module Ruspea::Prim
  class Sym
    attr_reader :label

    def initialize(label)
      @label = label
    end

    def eq?(other)
      self == other
    end

    def eql?(other)
      self == other
    end

    def ==(other)
      return false if self.class != other.class
      self.label == other.label
    end
  end
end
