module Ruspea
  class Evaler
    def eval(expr, ctx = nil)
      ctx ||= Core::Context.new
      return expr if prim?(expr)
      return list(expr, ctx) if list?(expr)
      return ctx.resolve(expr) if sym?(expr)
      raise Error::Execution.new("Invalid Expression")
    end

    def prim?(expr)
      expr.is_a?(Numeric) ||
        expr.is_a?(String) ||
        expr.is_a?(TrueClass) || expr.is_a?(FalseClass) ||
        expr == Core::Nill.instance
    end

    def list?(expr)
      expr.is_a?(Core::List) || expr.is_a?(Core::Nill)
    end

    private

    def sym?(expr)
      expr.is_a?(Core::Symbol)
    end

    def list(expr, ctx)
      operand = String(expr.head)
      raise not_a_fun(operand) if !ctx.defined?(operand)

      invokable(operand, ctx)
        .call(expr.tail) { |expr, new_ctx = nil|
          self.eval(expr, ctx)
          # we will need something like:
          # invokation_ctx =
          #   if !new_ctx.nil?
          #     ctx.around new_ctx
          #   else
          #     ctx
          #   end

          # self.eval(expr, invokation_ctx)
        }
    end

    def not_a_fun(operand)
      Error::Execution.new "#{operand} is not a function"
    end

    def invokable(operand, ctx)
      target = ctx.resolve(operand)
      return target if target.respond_to?(:call)
      target.method(operand)
    end
  end
end
