module Ruspea
  class Evaluator
    include Core::Predicates

    def eval(expr, env = Core::Environment.new)
      return expr if prim?(expr)
      return sym(expr, env) if sym?(expr)
      return list(expr, env) if list?(expr)
    end

    private

    def sym(expr, env)
      env[expr]
    end

    def list(expr, env)
      fun = as_callable(expr.head, env)
      fun.call(expr.tail, env)
    end

    def as_callable(to_call, env)
      return list(to_call, env) if list?(to_call) # to allow inline invocation
      env[to_call].tap { |fun|
        raise not_callable_error(fun) if !fun.respond_to?(:call)
      }
    end

    def not_callable_error(label)
      Error::Execution.new <<~ERR
        Unable to treat #{label} as a callable thing
      ERR
    end

    def prim?(expr)
      string?(expr) ||
        numeric?(expr) ||
        bool?(expr)
    end
  end
end
