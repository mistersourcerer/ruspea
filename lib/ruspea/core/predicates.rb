module Ruspea
  module Core::Predicates
    def list?(expr)
      expr.respond_to?(:head) && expr.respond_to?(:tail)
    end

    def sym?(expr)
      expr.is_a?(Core::Symbol)
    end
  end
end
