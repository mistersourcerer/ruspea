module Ruspea::Interpreter::Forms
  class List
    include Ruspea::Interpreter::Form

    class << self
      def match?(code)
        code[0] == "("
      end

      def read(code, position = Position::INITIAL)
        new_position = position + 1
        remaining = code[1..code.length]
        remaining, new_position, list = next_until_end(remaining, new_position)
        [new(list, position), remaining, new_position + 1]
      end

      def next_until_end(remaining, new_position)
        finished = remaining.nil? && remaining.length == 0
        raise "Expected to find a ) for list at #{position}" if finished

        reader = Ruspea::Interpreter::Reader.new
        list = Ruspea::Runtime::Nill.instance

        form, remaining, new_position = reader.next(remaining, new_position)
        if form.is_a?(Separator)
          form, remaining, new_position = reader.next(remaining, new_position)
        end

        if remaining[0] != ")"
          remaining, new_position, list =
            next_until_end(remaining, new_position)
          [remaining, new_position, list.cons(form)]
        else
          [
            remaining[1..remaining.length],
            new_position,
            Ruspea::Runtime::Nill.instance.cons(form)]
        end
      end
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
