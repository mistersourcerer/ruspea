module Ruspea
  class Core::Function
    EVALUATOR = Evaluator.new

    attr_reader :arity

    def initialize(parameters, body, environment)
      @parameters = parameters
      @arity = parameters.size
      @body = body
      @env = environment
    end

    def call(args, evaluator: EVALUATOR)
      raise arguments_error(args.size) if args.size != arity
      bind(args)
      body.reduce(nil) { |_, expr|
        evaluator.eval(expr, env)
      }
    end

    private

    attr_reader :env, :body, :parameters

    def arguments_error(passed)
      Error::Execution.new <<~ERR
        Wrong number of args: #{passed} passed, #{arity} expected.
      ERR
    end

    def bind(args)
      parameters.each_with_index { |param, idx|
        env[param] = args.at(idx)
      }
    end
  end
end
