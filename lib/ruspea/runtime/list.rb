module Ruspea::Runtime
  class List
    attr_reader :head, :tail

    def self.create(*items)
      return new(nil, nil) if items.length == 0
      new items[0], create(*items[1..items.length])
    end

    def initialize(head, tail)
      @head = head
      @tail = tail
    end

    def car
      head
    end

    def cdr
      tail
    end

    def eq?(other)
      self == other
    end

    def eql?(other)
      self == other
    end

    def ==(other)
      return false if self.class != other.class
      head == other.head && tail == other.tail
    end
  end
end
