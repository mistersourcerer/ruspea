module Ruspea::Interpreter
  class Reader
    include Ruspea::Interpreter::Forms

    def next(code, position = Position::INITIAL)
      type = MATCHERS.find(method(:no_form_found)) { |t|
        t.match?(code)
      }

      type.read(code, position)
    end

    private

    MATCHERS = [
      Ruspea::Interpreter::Matchers::Numeric.new,
      String,
      Ruspea::Interpreter::Matchers::Array.new,
      Map,
      List,
      Quote,
      Ruspea::Interpreter::Matchers::Line.new,
      Separator,
      Ruspea::Interpreter::Matchers::Comment.new,
      Symbol,
    ]

    def code_to_forms(string)
      []
    end

    def no_form_found
      raise "No form was recognized."
    end
  end
end
