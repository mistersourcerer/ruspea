module Ruspea
  class Printer::Matchers::Symbol
    def print(symbol)
      symbol.value.to_s
    end
  end
end
