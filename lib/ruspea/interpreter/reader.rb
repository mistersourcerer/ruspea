module Ruspea::Interpreter
  class Reader
    include Ruspea::Interpreter::Forms

    def next(code, position: Position::INITIAL)
      type = FORMS.find(method(:no_form_found)) { |t|
        t.match?(code)
      }

      type.read(code, position)
    end

    private

    FORMS = [
      Numeric,
      String,
    ]

    def code_to_forms(string)
      []
    end

    def no_form_found
      raise "nope"
    end
  end
end
