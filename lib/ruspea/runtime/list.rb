module Ruspea::Runtime
  class List
    attr_reader :head, :tail, :count

    def self.create(*items)
      return Empty.instance if items.length == 0

      joining_lists =
        items.length == 2 &&
        (items[1].is_a?(List) || items[1] == Empty.instance)
      return new items[0], items[1], count: items[1].count + 1 if joining_lists

      new items[0], create(*items[1..items.length]), count: items.length
    end

    def initialize(head, tail = Empty.instance, count: 0)
      @head = head
      @tail = tail
      @count = count
    end

    def cons(el)
      return self.class.create(el) if empty?

      self.class.create el, self
    end

    def car
      head
    end

    def cdr
      tail
    end

    def empty?
      head.nil? && tail.empty?
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
