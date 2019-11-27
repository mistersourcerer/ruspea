module Ruspea
  class Printer::Matchers::List
    def initialize
      @printer = Printer.new
    end

    def print(list)
      return print_special(list) if special?(list)

      "(#{values(list)})"
    end

    private

    def special?(list)
      list.head == Forms::Symbol.new("quote")
    end

    def print_special(list)
      # For now, only quote
      "'#{@printer.call(list.tail.head)}"
    end

    def values(list)
      list
        .to_a
        .map { |value| @printer.call(value) }
        .join(" ")
    end
  end
end
