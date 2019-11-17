module Ruspea::Interpreter::Forms
  class Keyword
    include Ruspea::Interpreter::Form

    def cast(string)
      string.to_sym
    end
  end
end
