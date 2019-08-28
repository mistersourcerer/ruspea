module Ruspea::Interpreter
  class Reader
    include Ruspea::Runtime
    include Ruspea::Error

    def call(source, forms = [])
      return [source, forms] if source.empty?

      code = to_list(source)

      rest, new_form =
        case code.head
        when DELIMITERS
          # Closing lists, arrays, etc...
          return [code, forms]
        when SEPARATOR
          # ignore separators
          [code.tail, nil]
        when STRING
          stringfy(code.tail)
        when DIGIT
          numberify(code.tail, code.head)
        when LIST_OPEN
          listify(code.tail)
        when ARRAY_OPEN
          arraify(code.tail)
        when QUOTE
          quotify(code.tail)
        else
          symbolize(code)
        end

      new_forms = new_form.nil? ? forms : forms + [new_form]
      call(rest, new_forms)
    end

    private

    SEPARATOR = /\A[,\s]/
    STRING = /\A"/
    DIGIT = /\A[\d-]/
    NUMERIC = /\A[\d_]/
    QUOTE = /\A'/
    LIST_OPEN = /\A\(/
    LIST_CLOSE = /\A\)/
    ARRAY_OPEN = /\A\[/
    ARRAY_CLOSE = /\A\]/
    DELIMITERS = Regexp.union(LIST_CLOSE, ARRAY_CLOSE)
    ENDER = Regexp.union(SEPARATOR, DELIMITERS)

    def to_list(source)
      return source if source.is_a?(Ruspea::Runtime::List)

      Ruspea::Runtime::List.create(*source.chars)
    end

    def stringfy(code, string = "")
      finished = code.head == "\"" || code.empty?
      return [code.tail, Form.new(string, closed: !code.empty?)] if finished

      stringfy(code.tail, string + code.head)
    end

    def numberify(code, number = "")
      return floatfy(code.tail, number + code.head) if code.head == "."

      finished = code.empty? || !NUMERIC.match?(code.head)
      return [code, Form.new(Integer(number))] if finished

      numberify(code.tail, number + code.head)
    end

    def floatfy(code, number)
      finished = code.empty? || !NUMERIC.match?(code.head)
      return [code.tail, Form.new(Float(number))] if finished

      floatfy(code.tail, number + code.head)
    end

    def listify(code)
      more_code, forms = call(code)
      closed = LIST_CLOSE.match?(more_code.head)
      form = Form.new(List.create(*forms), closed: closed)

      [more_code.tail, form]
    end

    def arraify(code)
      more_code, forms = call(code)
      form = Form.new(forms, closed: ARRAY_CLOSE.match?(more_code.head))

      [more_code.tail, form]
    end

    def quotify(code)
      more_code, content = call(code)

      invocation = List.create(
        Form.new(Sym.new("quote")),
        *content
      )

      [more_code, Form.new(invocation)]
    end

    def symbolize(code, word = "")
      finished = code.empty? || ENDER.match?(code.head)
      return [code, Form.new(read_word(word))] if finished

      symbolize(code.tail, word + code.head)
    end

    def read_word(word)
      return word == "true" if word == "true" || word == "false"
      return nil if word == "nil"

      Sym.new(word)
    end
  end
end
