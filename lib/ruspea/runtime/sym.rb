module Ruspea::Runtime
  class Sym
    def initialize(id)
      @id = String(id)
    end

    def ==(other)
      return false if self.class != other.class
      @id == other.id
    end

    def to_s
      @id
    end

    def print
      @id
    end

    protected

    attr_reader :id
  end
end
