module Ruspea::Reader
  class Read
    include Ruspea::Runtime
    include Lisp

    def call(code)
      return nil if code.length == 0

      source = Str.create code
      case source.head
      when "("
        read_list source.tail
      end
    end

    def read_list(source, token = "", list = [])
      # TODO: raises if no ) was found
      return list if source.empty?

      if source.head == ")"
        return list + [token] if token.length > 0
        return list
      end

      if source.head == " " || source.head == ","
        # consume all separators
        read_list source.tail, "",  list + [token]
      else
        read_list source.tail, token + source.head, list
      end
    end
  end
end
