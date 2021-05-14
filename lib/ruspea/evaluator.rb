module Ruspea
  class Evaluator
    ENV = Core::Environment.new

    def eval(expr, env = ENV)
      return expr if prim?(expr)
      return sym(expr, env) if sym?(expr)
    end

    private

    def sym(expr, env)
      env[expr]
    end

    def prim?(expr)
      expr.is_a?(String) ||
        expr.is_a?(Numeric)
    end

    def sym?(expr)
      expr.is_a?(Core::Symbol)
    end
  end
end
