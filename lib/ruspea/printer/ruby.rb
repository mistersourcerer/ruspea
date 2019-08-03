module Ruspea::Printer
  class Ruby
    def initialize(form)
      @form = form
      @printer = Ruspea::Printer::Print.new
      @lisp = Ruspea::Runtime::Lisp.new
    end

    def call
      case @form
      when Array
        printable_array @form
      when LIST
        printable_list @form
      when nil
        "nil"
      else
        "#{@form.inspect} /* ::#{@form.class} */"
      end
    end

    private

    LIST = Ruspea::Runtime::List

    def printable_array(array)
      elements = array.take(10)
      to_print = elements.map { |el| @printer.printable(el) }

      nested = elements.any? { |el| el.is_a?(Array) || el.is_a?(LIST) }
      joiner = nested ? ",\n" : " "

      and_more = array.length > 10 ? " ...] // length: #{array.length}" : "]"

      "[#{to_print.join(joiner)}#{and_more}"
    end

    def printable_list(list)
      elements = @lisp.take(10, list).to_a
      to_print = elements.map { |el| @printer.printable el }

      nested = elements.any? { |el| el.is_a?(Array) || el.is_a?(LIST) }
      joiner = nested ? ",\n" : " "

      and_more = list.count > 10 ? " ...) // count: #{list.count}" : ")"
      "(#{to_print.join(joiner)}#{and_more}"
    end
  end
end
