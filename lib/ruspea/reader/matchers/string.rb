module Ruspea
  class Reader::Matchers::String
    def match?(code)
      code[0] == "\""
    end

    def read(code, position = Position::INITIAL, string = "", started: false)
      if code.length == 0
        raise "Expected to find \", but nothing was found [started at #{position}]"
      end

      remaining = code[1..code.length]

      if code[0] == "\""
        result =
          if started
            [
              Ruspea::Forms::String.new(string, position),
              remaining,
              position + string.length + 2
            ]
          else
            read(remaining, position, string, started: true)
          end

        return result
      end

      read(remaining, position, string + code[0], started: true)
    end
  end
end
