module Ruspea::Forms
  class Keyword
    include Ruspea::Form

    def cast(string)
      string.to_sym
    end
  end
end
