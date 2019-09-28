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

    def call(code)
      if @digit.match?(code.tail.head)
        @digit.call(code.tail, "-")
      else
        @symbol.call(code)
      end
    end
  end
end
