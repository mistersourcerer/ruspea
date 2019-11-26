module Ruspea
  class Printer::Matchers::String
    def print(value)
      "\"#{value.to_s}\""
    end
  end
end
