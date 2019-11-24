module Ruspea::Forms
  class List
    include Ruspea::Form

    def eval(context)
      fn = context[value.head] { |sym, error|
        puts "#{sym.value} is not a function!"
        raise error
      }
      fn.call(self.class.new(value.tail, value.tail.head.position))
    end

    def inspect
      return @inspect if @inspect

      values = value_to_a.map { |value|
        "  #{value.inspect}"
      }.join("\n")
      @inspect = "(%_form (\n#{values})\n  #{self.position.inspect}\n  \"#{self.class.name}\")"
    end

    private

    def value_to_a(list = nil, array = [])
      list ||= self.value
      return array if list.empty?

      value_to_a(list.tail, array + [list.head])
    end
  end
end
