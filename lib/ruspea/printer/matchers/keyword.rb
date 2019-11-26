module Ruspea
  class Printer::Matchers::Keyword
    def print(value)
      ":#{value.to_s}"
    end
  end
end
