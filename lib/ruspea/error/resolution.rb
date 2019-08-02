module Ruspea::Error
  class Resolution < Standard
    def initialize(symbol)
      super "Unable to resolve: #{symbol} in the current context"
    end
  end
end
