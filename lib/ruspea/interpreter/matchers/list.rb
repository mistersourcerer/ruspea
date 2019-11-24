module Ruspea::Interpreter::Matchers
  class List
    def match?(code)
      code[0] == "("
    end

    def read(code, position = Position::INITIAL)
      new_position = position + 1
      remaining, new_position, list =
        next_until_end(code[1..code.length], new_position)

      [
        Ruspea::Forms::List.new(list, position),
        remaining,
        new_position + 1
      ]
    end

    private

    def next_until_end(code, position)
      raise "Expected to find a ) for list at #{position}" if finished?(code)

      list = Ruspea::Runtime::Nill.instance
      form, remaining, new_position = ignore_separators(code, position)

      if remaining[0] != ")"
        remaining, new_position, list = next_until_end(remaining, new_position)
        [remaining, new_position, list.cons(form)]
      else
        [
          remaining[1..remaining.length],
          new_position,
          Ruspea::Runtime::Nill.instance.cons(form)]
      end
    end

    def finished?(code)
      code.nil? && code.length == 0
    end

    def ignore_separators(remaining, new_position)
      reader = Ruspea::Interpreter::Reader.new
      form, remaining, new_position = reader.next(remaining, new_position)

      if form.is_a?(Ruspea::Forms::Separator)
        form, remaining, new_position = reader.next(remaining, new_position)
      end

      [form, remaining, new_position]
    end
  end
end
