module Ruspea::Reader
  class Read

    def call(code, forms = [])
      return forms if code.nil? || code.length == 0

      char = code[0]
      remaining_code, new_forms =
        case char
        when SEPARATOR
          # ignore separators
          [code[1..code.length], forms]
        when NEWLINE
          binding.pry
          # ignore new line
          [code[1..code.length], forms]
        when QUOTE
          remaining_code, new_form =
            read_string(
              code[1..code.length])
          [remaining_code, forms + [new_form]]
        end

      call(remaining_code, new_forms)
    end

    private

    SEPARATOR = /\A[,\s]/
    NEWLINE = /\A\n/
    QUOTE = /\A"/

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
