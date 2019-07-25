module Ruspea::Runtime
  class Empty
    attr_reader :head, :tail

    def initialize(builder)
      @builder = builder
      @head = nil
      @tail = self
    end

    def cons(el)
      @builder.create el, self
    end

    def car
      nil
    end

    def cdr
      self
    end

    def empty?
      true
    end

    def eq?(other)
      self == other
    end

    def eql?(other)
      self == other
    end

    def ==(other)
      self.class == other.class &&
        builder.class == other.builder.class
    end

    protected

    attr_reader :builder
  end
end
