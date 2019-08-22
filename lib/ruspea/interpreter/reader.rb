module Ruspea::Interpreter
  class Reader
    include Ruspea::Runtime
    include Ruspea::Error

    def initialize
      @parser = Parser.new
    end

    def call(code)
      _, forms = @parser.call(code)
      # TODO: if remaining_code.length > 0 || forms.last[:closed] == false raise
      forms.map { |form|
        read(form)
      }
    end

    private

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
        read_list(form)
      when ARRAY
        eval_collection(form)
      end
    end

    def eval_collection(form)
      form[:content].map { |form|
        read(form)
      }
    end

    def read_list(form)
      content = eval_collection(form)

      if content.first == Sym.new("fn")
        read_fn(content)
      else
        List.create(*content)
      end
    end

    def read_fn(declaration)
      raise Syntax.new if declaration.length < 2

      no_params_message = <<~m
        fn first parameter should be an Array
        for a zero arity function, use (fn [] ...)
      m
      raise Syntax.new(no_params_message) if !declaration[1].is_a?(Array)

      body =
        if declaration.length > 2
          declaration[2..declaration.length]
        else
          []
        end

      List.create(declaration[0], declaration[1], body)
    end
  end
end
