module Ruspea::Error
  class ArityVarargs < Standard
    def initialize(expected, received)
      super "Expected #{expected} (or more) args, but received #{received}"
    end
  end
end
