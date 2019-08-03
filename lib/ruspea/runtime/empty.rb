require "singleton"

module Ruspea::Runtime
  class Empty
    include Singleton

    attr_reader :head, :tail

    def cons(el)
      List.new el, self, count: 1
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

    def count
      0
    end

    def to_a
      ARRAY
    end

    private

    ARRAY = []
  end
end
