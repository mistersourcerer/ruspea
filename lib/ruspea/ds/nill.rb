require "singleton"

module Ruspea::DS
  class Nill
    include Singleton

    ARRAY = [].freeze

    def head
      nil
    end

    def car
      nil
    end

    def tail
      self
    end

    def cdr
      self
    end

    def count
      0
    end

    def cons(el)
      return List.new(el, self, count: 1)
    end

    def empty?
      true
    end

    def to_a(*_)
      ARRAY
    end

    def eq?(other)
      self == other
    end

    def eql?(other)
      self == other
    end

    def ==(other)
      return true if other.is_a? Nill
      false
    end
  end
end
