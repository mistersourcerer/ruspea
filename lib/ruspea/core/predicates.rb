module Ruspea
  module Core::Predicates
    def list?(*exprs)
      exprs.all? { |expr| expr.respond_to?(:head) && expr.respond_to?(:tail) }
    end

    def sym?(*exprs)
      exprs.all? { |expr| expr.is_a?(Core::Symbol) }
    end

    def numeric?(*exprs)
      exprs.all? { |expr| expr.is_a?(Numeric) }
    end

    def bool?(*exprs)
      exprs.all? { |expr| expr.is_a?(TrueClass) || expr.is_a?(FalseClass) }
    end

    def string?(*exprs)
      exprs.all? { |expr| expr.is_a?(String) }
    end
  end
end
