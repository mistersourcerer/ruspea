module Ruspea::Interpreter
  class Reader
    include Ruspea::Runtime

    class TokenTyper
      def initialize(type)
        @type = type
      end

      def ===(token)
        type == token[:type]
      end

      private

      attr_reader :type
    end

    STRING = TokenTyper.new(String)
    INTEGER = TokenTyper.new(Integer)
    FLOAT = TokenTyper.new(Float)
    LIST = TokenTyper.new(List)
    SYM = TokenTyper.new(Sym)

    def initialize
      @parser = Parser.new
    end

    def call(code)
      remaining_code, forms = @parser.call(code)
      # TODO: if remaining_code.length > 0 || forms.last[:closed] == false raise
      forms.map { |form|
        read(form)
      }
    end

    private

    def read(token)
      case token
      when INTEGER
        Integer(token[:content])
      when FLOAT
        Float(token[:content])
      when STRING
        token[:content]
      when SYM
        Sym.new(token[:content])
      when LIST
        contents = token[:content].map { |form|
          read(form)
        }
        List.create(*contents)
      end
    end
  end
end
