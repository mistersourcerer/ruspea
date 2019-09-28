module Ruspea::Interpreter::Forms
  class String
    STRING = /\A"/

    def match?(char)
      STRING.match? char
    end

    def call(code, string = "")
      # ignore opening quote
      return call(code.tail) if match?(code.head) && string.length == 0

      if finished?(code)
        [code.tail, Ruspea::Interpreter::Form.new(string, closed: !code.empty?)]
      else
        call(code.tail, string + code.head)
      end
    end

    private

    def finished?(code)
      code.empty? || match?(code.head)
    end
  end
end
