module Ruspea
  class Printer
    include Ruspea::Runtime

    def call(value)
      case value
      when String
        value.inspect
      when Numeric
        value.inspect
      when Sym
        value.to_s
      else
        value.inspect
      end
    end
  end
end
