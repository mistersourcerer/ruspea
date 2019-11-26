module Ruspea
  class Reader::Matchers::Quote
    include Forms

    def match?(code)
      code[0] == "'"
    end

    def read(code, position = Position::INITIAL)
      reader = Reader.new
      form, remaining, new_position = reader.next(code[1..code.length], position + 1)
      [quote(form, position), remaining, new_position]
    end

    private

    def quote(form, position)
      List.new(
        Runtime::List.create(
          Symbol.new(
            "quote",
            Position.new(0, 0)
          ),
          form
        ), position
      )
    end
  end
end
