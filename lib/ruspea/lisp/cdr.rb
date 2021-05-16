module Ruspea
  class Lisp::Cdr
    include Core::Predicates
    include Lisp::Errors

    def call(args, _)
      raise arg_type_error(args) if !list?(args) || !list?(args.head)
      raise args_error(args.size, 1) if args.empty? || args.size != 1
      args.head.tail
    end
  end
end
