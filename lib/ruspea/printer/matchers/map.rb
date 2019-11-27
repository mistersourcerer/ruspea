module Ruspea
  class Printer::Matchers::Map
    def initialize
      @printer = Printer.new
    end

    def print(map)
      values = map.to_h.flat_map { |k, v|
        "#{k}: #{v}"
      }.join " "
      "{#{values}}"
    end
  end
end
