module Ruspea
  class Lisp::Car
    include Core::Predicates
    include Lisp::Errors

    def call(args, _)
      raise arg_type_error(args) if !list?(args)
      raise arg_type_error(args.head) if !list?(args.head)
      check_args(args, 1)
      args.head.head
    end
  end
end
