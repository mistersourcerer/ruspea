module Ruspea::Interpreter
  class Parser
    include Ruspea::Runtime

    def call(code, forms = [])
      return ["", forms] if code.nil? || code.length == 0

      remaining_code, new_form =
        case code[0]
        when DELIMITERS
          return [code, forms]
        when SEPARATOR
          # ignore separators
          [code[1..code.length], nil]
        when QUOTE
          read_string(code[1..code.length])
        when DIGIT
          read_number(code[1..code.length], code[0])
        when LIST_OPEN
          read_list(code[1..code.length])
        when ARRAY_OPEN
          read_array(code[1..code.length])
        else
          read_symbol(code)
        end

      new_forms = new_form.nil? ? forms : forms + [new_form]
      call(remaining_code, new_forms)
    end

    private

    SEPARATOR = /\A[,\s]/
    QUOTE = /\A"/
    DIGIT = /\A[\d-]/
    NUMERIC = /\A[\d_]/
    LIST_OPEN = /\A\(/
    LIST_CLOSE = /\A\)/
    ARRAY_OPEN = /\A\[/
    ARRAY_CLOSE = /\A\]/
    DELIMITERS = Regexp.union(LIST_CLOSE, ARRAY_CLOSE)
    ENDER = Regexp.union(SEPARATOR, DELIMITERS)

    def read_string(code, current_string = "")
      if code[0] == "\""
        return tuple(code[1..code.length], String, current_string)
      end

      if code.length == 0
        return tuple("", String, current_string, false)
      end

      new_string = current_string + code[0]
      read_string(code[1..code.length], new_string)
    end

    def read_number(code, current_number = "")
      if code[0] == "."
        return read_float(code[1..code.length], current_number + code[0])
      end

      if code.length == 0 || !code[0].match?(NUMERIC)
        return tuple(code, Integer, current_number)
      end

      read_number(code[1..code.length], current_number + code[0])
    end

    def read_float(code, current_number)
      if code.length == 0 || !code[0].match?(NUMERIC)
        return tuple(code, Float, current_number)
      end

      read_float(code[1..code.length], current_number + code[0])
    end

    def read_list(code)
      read_collection(code, List, LIST_CLOSE)
    end

    def read_array(code)
      read_collection(code, Array, ARRAY_CLOSE)
    end

    def read_symbol(code, current_symbol = "")
      if code.length == 0 || code[0].match?(ENDER)
        return tuple(code, Sym, current_symbol)
      end

      read_symbol(code[1..code.length], current_symbol + code[0])
    end

    def read_collection(code, type, close_with)
      remaining_code, forms = call(code)
      closed =
        remaining_code.length > 0 && remaining_code[0].match?(close_with)
      tuple(
        remaining_code[1..remaining_code.length], type, forms, closed)
    end

    def tuple(code, type, content, closed = true)
      [
        code,
        build_form(type, content, closed)
      ]
    end

    def build_form(type, content, closed)
      {
        type: type,
        content: content,
        closed: closed
      }
    end
  end
end
