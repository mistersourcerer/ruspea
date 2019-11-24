module Ruspea::Forms
  class Float
    include Ruspea::Form

    def cast(string)
      Float(string)
    end
  end
end
