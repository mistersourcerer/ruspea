module Ruspea::Runtime
  class Keyword
    def initialize(id)
      @id = String(id.gsub(ENDING, ""))
    end

    def print
      @id
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

    protected

    attr_reader :id

    private

    ENDING = /:\z/
  end
end
