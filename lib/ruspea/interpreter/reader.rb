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
      def initialize(*types)
        @types = types
      end

      def ===(token)
        return true if types.find { |type| type == token[:type] }
        false
      end

      private

      attr_reader :types
    end

    STRING = TokenTyper.new(String)
    INTEGER = TokenTyper.new(Integer)
    FLOAT = TokenTyper.new(Float)
    LIST = TokenTyper.new(List)
    SYM = TokenTyper.new(Sym)
    ARRAY = TokenTyper.new(Array)
    BOOLEAN = TokenTyper.new(TrueClass, FalseClass)

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
      when BOOLEAN
        form[:content] == "true"
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
      elsif content.first == Sym.new("cond")
        read_cond(content)
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

    def read_cond(invocation)
      content = invocation[1..invocation.length]
      no_tuples = <<~m
        cond expects a series of [test tuples].
        eg.:
          (cond
            (it_is_true?) (then_do_something)
            true 1)
      m
      raise Syntax.new(no_tuples) if (content.count % 2) != 0

      body = content
        .each_slice(2)
        .reduce([]) { |tuples, tuple|
          tuples << [tuple[0], tuple[1]]
        }

      List.create(invocation.first, body)
    end
  end
end
