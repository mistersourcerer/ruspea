module Ruspea::Interpreter::Forms
  class Float
    include Ruspea::Interpreter::Form

    def cast(string)
      Float(string)
    end
  end
end
