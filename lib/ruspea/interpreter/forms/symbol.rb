module Ruspea::Interpreter::Forms
  class Symbol
    SEPARATOR = /\A[,\s]/
    LIST_CLOSE = /\A\)/
    ARRAY_CLOSE = /\A\]/
    DELIMITERS = Regexp.union(LIST_CLOSE, ARRAY_CLOSE)
    ENDER = Regexp.union(SEPARATOR, DELIMITERS)

    def match?(_)
      true
    end

    def read(code, word = "")
      if finished?(code)
        value, evaler = read_word(word)
        [
          code,
          Ruspea::Interpreter::Form.new(value, evaler: evaler)]
      else
        read(code.tail, word + code.head)
      end
    end

    private

    def finished?(code)
      code.empty? || ENDER.match?(code.head)
    end

    def read_word(word)
      case
      when word == "true" || word == "false"
        [word == "true", ->(bool, _, _) { bool }]
      when word == "nil"
        [nil, ->(_, _, _) { nil }]
      else
        [Ruspea::Runtime::Sym.new(word), method(:eval_symbol)]
      end
    end

    def eval_symbol(symbol, context, _)
      context[symbol]
    end
  end
end
