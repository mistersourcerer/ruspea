module Ruspea
  class Core::Function
    attr_reader :arity

    def initialize(parameters, body, context)
      @parameters = parameters
      @arity = parameters.size
      @body = body
      @ctx = context
    end

    def call(args)
      raise arguments_error(args.size) if args.size != arity
      bind(args)
      body.reduce(nil) { |_, expr|
        ctx.eval(expr)
      }
    end

    private

    attr_reader :ctx, :body, :parameters

    def arguments_error(passed)
      Error::Execution.new <<~ERR
        Wrong number of args: #{passed} passed, #{arity} expected.
      ERR
    end

    def bind(args)
      parameters.each_with_index { |param, idx|
        ctx[param] = args.at(idx)
      }
    end
  end
end
