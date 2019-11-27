module Ruspea
  class Error::Resolution < Error::Standard
    def initialize(symbol)
      value = symbol.respond_to?(:value) ? symbol.value : symbol
      super "Unable to resolve: #{value} in the current context"
    end
  end
end
