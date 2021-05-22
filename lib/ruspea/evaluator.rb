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
      fun =
        if list?(expr.head) # allow for inline invocation
          list(expr.head, env)
        else
          as_callable(expr.head, env)
        end

      eval_args = fun.respond_to?(:eval_args?) ? fun.eval_args? : true
      args =
        if eval_args
          expr.tail.map { |e| self.eval(e, env) }
        else
          expr.tail
        end
      fun.call(args, env)
    end

    def as_callable(to_call, env)
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
