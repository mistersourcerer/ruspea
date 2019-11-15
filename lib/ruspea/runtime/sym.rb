module Ruspea::Runtime
  class Sym
    def initialize(id)
      @id = String(id.to_s)
    end

    def to_s
      @id
    end

    def eql?(other)
      self == other
    end

    def ==(other)
      return false if self.class != other.class
      @id == other.id
    end

    def hash
      @id.hash + :rsp_sym.hash
    end

    def match?(regexp)
      @id.match?(regexp)
    end

    protected

    attr_reader :id
  end
end
