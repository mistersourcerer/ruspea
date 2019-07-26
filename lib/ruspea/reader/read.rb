module Ruspea::Reader
  class Read
    include Ruspea::Runtime
    include Lisp

    def call(source)
      return Empty.instance if source.length == 0

      case source[0]
      when "("
        read_list source[1..source.length]
      end
    end

    def read_list(source, token = "", list = [])
      # TODO: raises if no ) was found
      return list if source.length == 0

      if source[0] == ")"
        return list + [token] if token.length > 0
        return list
      end

      if source[0] == " " || source[0] == ","
        # consume all separators
        read_list source[1..source.length], "",  list + [token]
      else
        read_list source[1..source.length], token + source[0], list
      end
    end
  end
end
