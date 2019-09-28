module Ruspea::Interpreter::Forms
  class Symbol
    SEPARATOR = /\A[,\s]/
    LIST_CLOSE = /\A\)/
    ARRAY_CLOSE = /\A\]/
    DELIMITERS = Regexp.union(LIST_CLOSE, ARRAY_CLOSE)
    ENDER = Regexp.union(SEPARATOR, DELIMITERS)

    def match?(*_)
      true
    end

    def call(code, word = "")
      if finished?(code)
        [code, Ruspea::Interpreter::Form.new(read_word(word))]
      else
        call(code.tail, word + code.head)
      end
    end

    private

    def finished?(code)
      code.empty? || ENDER.match?(code.head)
    end

    def read_word(word)
      return word == "true" if word == "true" || word == "false"
      return nil if word == "nil"

      Ruspea::Runtime::Sym.new(word)
    end
  end
end
