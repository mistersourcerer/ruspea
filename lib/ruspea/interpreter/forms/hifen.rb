module Ruspea::Interpreter::Forms
  class Hifen
    HIFEN = /\A-/

    def initialize
      @digit = Digit.new
      @symbol = Symbol.new
    end

    def match?(char)
      HIFEN.match? char
    end

    def read(code)
      if @digit.match?(code.tail.head)
        @digit.read(code.tail, "-")
      else
        @symbol.read(code)
      end
    end
  end
end
