module Ruspea::Interpreter::Forms
  class Digit
    DIGIT = /\A\d/
    NUMERIC = /\A[\d_]/
    SEPARATOR = /\A[,\s]/

    def initialize
      @symbol = Symbol.new
    end

    def match?(char)
      DIGIT.match? char
    end

    def read(code, number = "")
      return float(code.tail, number + code.head) if code.head == "."
      if finished?(code)
        return [
          code,
          Ruspea::Interpreter::Form.new(Integer(number), evaler: method(:eval))]
      end

      read(code.tail, number + code.head)
    end

    private

    def finished?(code)
      code.empty? ||
        !NUMERIC.match?(code.head) ||
        SEPARATOR.match?(code.head)
    end

    def float(code, number)
      if finished?(code)
        [code.tail, Ruspea::Interpreter::Form.new(Float(number))]
      else
        float(code.tail, number + code.head)
      end
    end

    def eval(num, _, _)
      num
    end
  end
end
