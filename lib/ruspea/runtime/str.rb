module Ruspea::Runtime
  class Str
    EMPTY = Empty.new(self)
    attr_reader :head, :tail

    def self.create(*items)
      string = items.map(&:to_s).join
      return EMPTY if string.length == 0

      new string
    end

    def initialize(string)
      @string = string

      if @string.length == 0
        @head = nil
        @tail = EMPTY
      else
        @head = string[0]
        @tail = self.class.new string[1..@string.length]
      end
    end

    def cons(item)
      return self.class.create(item) if empty?

      self.class.create item, self
    end

    def car
      head
    end

    def cdr
      tail
    end

    def empty?
      false
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

    def to_s
      @string
    end
  end
end
