module Ruspea
  class Lisp::Quote
    include Core::Predicates
    include Lisp::Errors

    def call(args, _)
      raise arg_type_error(args) if !list?(args)
      check_args(args, 1)
      args.head
    end

    def eval_args?
      false
    end
  end
end
