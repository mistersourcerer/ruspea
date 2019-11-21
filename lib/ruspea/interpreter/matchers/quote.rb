module Ruspea::Interpreter::Matchers
  class Quote
    def match?(code)
      code[0] == "'"
    end

    def read(code, position = Position::INITIAL)
      reader = Ruspea::Interpreter::Reader.new
      form, remaining, new_position = reader.next(code[1..code.length], position + 1)
      [quote(form, position), remaining, new_position]
    end

    private

    def quote(form, position)
      Ruspea::Interpreter::Forms::List.new(
        Ruspea::Runtime::List.create(
          Ruspea::Interpreter::Forms::Symbol.new(
            "quote",
            Ruspea::Interpreter::Position.new(0, 0)
          ),
          form
        ), position
      )
    end
  end
end
