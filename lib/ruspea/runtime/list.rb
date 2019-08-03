module Ruspea::Runtime
  class List
    attr_reader :head, :tail, :count

    def self.create(*items, list: Empty.instance)
      return Empty.instance if items.length == 0

      new items[0], create(*items[1..items.length]), count: items.length
    end

    def initialize(head, tail = Empty.instance, count: 0)
      @head = head
      @tail = tail
      @count = count
      @lisp = Lisp.new
      @printer = Ruspea::Printer::Print.new
    end

    def cons(el)
      return self.class.create(el) if empty?

      self.class.new el, self, count: @count + 1
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

    def inspect
      @printer.printable(self)
    end

    def to_a(list = self, array = [])
      return array if list.empty?

      to_a(list.tail, array + [list.head])
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
