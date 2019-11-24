module Ruspea::Runtime
  class List
    attr_reader :head, :tail, :count

    def self.create(*items)
      return Nill.instance if items.length == 0

      new items[0], create(*items[1..items.length]), count: items.length
    end

    def self.cons(el, list)
      raise "Can't consing #{el} int not a list: #{list}" if !list.respond_to?(:cons)
      list.cons(el)
    end

    def initialize(head, tail = Nill.instance, count: 0)
      @head = head
      @tail = tail
      @count = count
    end

    def cons(el)
      self.class.new el, self, count: @count + 1
    end

    def car
      head
    end

    def cdr
      tail
    end

    def take(amount, from = self)
      return Nill.instance if amount == 0 || from.empty?

      from
        .take(amount - 1, from.tail)
        .cons(from.head)
    end

    def map(fun = nil, list: self, &callable)
      raise "not ready!"
      return Nill.instance if list.empty?

      mapper =
        if !callable.nil?
          callable
        else
          fun || ->(item) { item }
        end
    end

    def empty?
      false
    end

    def to_a(list = self, array = [])
      return array if list.empty?

      to_a(
        list.tail,
        array + [list.head])
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
