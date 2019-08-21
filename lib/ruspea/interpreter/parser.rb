module Ruspea::Interpreter
  class Parser
    def call(code, forms = [])
      return ["", forms] if code.nil? || code.length == 0

      char = code[0]
      remaining_code, new_forms =
        case char
        when LIST_CLOSE
          return [code, forms]
        when SEPARATOR
          # ignore separators
          [code[1..code.length], forms]
        when QUOTE
          remaining_code, new_form =
            read_string(
              code[1..code.length])
          [remaining_code, forms + [new_form]]
        when DIGIT
          remaining_code, new_form =
            read_number(
              code[1..code.length], code[0])
          [remaining_code, forms + [new_form]]
        when LIST_OPEN
          remaining_code, new_form =
            read_list(
              code[1..code.length])
          [remaining_code, forms + [new_form]]
        end

      call(remaining_code, new_forms)
    end

    private

    SEPARATOR = /\A[,\s]/
    QUOTE = /\A"/
    DIGIT = /\A[\d-]/
    NUMERIC = /\A[\d_]/
    LIST_OPEN = /\A\(/
    LIST_CLOSE = /\A\)/

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
      read_collection(code, Ruspea::Runtime::List, LIST_CLOSE)
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
