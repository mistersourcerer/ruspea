module Ruspea::Interpreter::Forms
  class String
    STRING = /\A"/

    def match?(char)
      STRING.match? char
    end

    def read(code, string = "")
      # ignore opening quote
      return read(code.tail) if match?(code.head) && string.length == 0

      if finished?(code)
        [
          code.tail,
          Ruspea::Interpreter::Form.new(
            string, closed: !code.empty?, evaler: method(:eval))]
      else
        read(code.tail, string + code.head)
      end
    end

    private

    def finished?(code)
      code.empty? || match?(code.head)
    end

    def eval(string, _, _)
      string
    end
  end
end
