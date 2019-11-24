module Ruspea::Forms
  class Integer
    include Ruspea::Form

    def cast(string)
      Integer(string)
    end
  end
end
