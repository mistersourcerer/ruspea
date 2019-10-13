module Ruspea::Interpreter::Forms
  class Quote
    QUOTE = /\A'/

    def initialize
      @reader = Ruspea::Interpreter::Reader.new
    end

    def match?(char)
      QUOTE.match? char
    end

    def read(code)
      more_code, content = @reader.call(code.tail)
      invocation = Ruspea::Runtime::List.create(quote_symbol, *content)
      [more_code, Ruspea::Interpreter::Form.new(invocation)]
    end

    private

    def quote_symbol
      @sym ||= Ruspea::Interpreter::Form.new(Ruspea::Runtime::Sym.new("quote"))
    end
  end
end
