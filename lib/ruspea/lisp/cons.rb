module Ruspea
  class Lisp::Cons
    include Core::Predicates
    include Lisp::Errors

    def call(args, _)
      raise arg_type_error(args) if !list?(args)
      raise args_error(args.size, 2) if args.empty? || args.size != 2
      raise arg_type_error(args.tail.head) if !list?(args.tail.head)
      expr, list = args.head, args.tail.head
      list.cons(expr)
    end
  end
end
