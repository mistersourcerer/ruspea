require "singleton"

module Ruspea::Runtime
  class Empty
    include Singleton

    attr_reader :head, :tail

    def cons(el)
      List.create el, self
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
  end
end