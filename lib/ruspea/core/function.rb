module Ruspea
  class Core::Function
    EVALUATOR = Evaluator.new

    attr_reader :arity

    def initialize(parameters, body, closure)
      @parameters = parameters
      @arity = parameters.size
      @body = body
      @closure = closure
    end

    def call(args, invocation_env, evaluator: EVALUATOR)
      raise arguments_error(args.size) if args.size != arity

      execution_env = closure
        .push(invocation_env)
        .push(bind(args))

      body.reduce(nil) { |_, expr|
        evaluator.eval(expr, execution_env)
      }
    end

    private

    attr_reader :closure, :body, :parameters

    def arguments_error(passed)
      Error::Execution.new <<~ERR
        Wrong number of args: #{passed} passed, #{arity} expected.
      ERR
    end

    def bind(args)
      parameters.each_with_index.reduce(Core::Environment.new) { |env, (param, idx)|
        env.tap { |e| e[param] = args.at(idx) }
      }
    end
  end
end
