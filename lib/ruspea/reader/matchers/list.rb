module Ruspea
  class Reader::Matchers::List
    def initialize
      @reader = Reader.new
      @separator = Reader::Matchers::Separator.new
    end

    def match?(code)
      code[0] == "("
    end

    def read(code, position = Position::INITIAL)
      new_position = position + 1
      list, remaining, new_position =
        next_until_end(code[1..code.length], new_position)

      [
        Forms::List.new(list, position),
        remaining,
        new_position + 1
      ]
    end

    private

    def next_until_end(code, position)
      raise "Expected to find a ) for list at #{position}" if finished?(code)

      remaining, new_position = ignore_separators(code, position)
      list = Runtime::Nill.instance

      if remaining[0] == ")"
        [
          list,
          remaining[1..remaining.length],
          new_position]
      else
        form, remaining, new_position = @reader.next(remaining, new_position)
        list, remaining, new_position = next_until_end(remaining, new_position)
        [
          list.cons(form),
          remaining,
          new_position
        ]
      end
    end

    def finished?(code)
      code.nil? && code.length == 0
    end

    def ignore_separators(code, position)
      return [code, position] if !@separator.match?(code)

      while(@separator.match?(code))
        _, code, position = @separator.read(code, position)
      end

      [code, position]
    end
  end
end
