module Ruspea
  class Lisp::Atom
    include Core::Predicates
    include Lisp::Errors

    def call(args, _)
      raise arg_type_error(args) if !list?(args)
      check_args(args, 1)
      atom?(args.head)
    end

    private

    def atom?(expr)
      return sym?(expr) ||
        list?(expr) && expr.empty? ||
        bool?(expr) ||
        numeric?(expr) ||
        expr.is_a?(String)
    end
  end
end
