module Ruspea
  class Lisp::Atom
    include Core::Predicates
    include Lisp::Errors

    def call(args, _)
      raise arg_type_error(args) if !list?(args)
      raise args_error(args.size, 1) if args.empty? || args.size != 1
      atom?(args.head)
    end

    private

    def atom?(expr)
      return sym?(expr) ||
        list?(expr) && expr.empty? ||
        expr.is_a?(TrueClass) || expr.is_a?(FalseClass) ||
        expr.is_a?(Numeric) ||
        expr.is_a?(String)
    end
  end
end
