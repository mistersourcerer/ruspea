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
    ARRAY = TokenTyper.new(Array)

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

    def read(form)
      case form
      when INTEGER
        Integer(form[:content])
      when FLOAT
        Float(form[:content])
      when STRING
        form[:content]
      when SYM
        Sym.new(form[:content])
      when LIST
        List.create(
          *eval_collection(form))
      when ARRAY
        eval_collection(form)
      end
    end

    def eval_collection(form)
      form[:content].map { |form|
        read(form)
      }
    end
  end
end
