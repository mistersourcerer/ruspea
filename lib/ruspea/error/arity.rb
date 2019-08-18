module Ruspea::Error
  class Arity < Standard
    def initialize(expected, received)
      super "Expected #{expected} args, but received #{received}"
    end
  end
end
