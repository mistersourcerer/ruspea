module Ruspea::Interpreter::Forms
  class Integer
    include Ruspea::Interpreter::Form

    def cast(string)
      Integer(string)
    end
  end
end
