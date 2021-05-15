module Ruspea
  class Lisp::Quote
    include Core::Predicates
    include Lisp::Errors

    def call(args, _)
      raise arg_type_error(args) if !list?(args)
      raise args_error(args.size, 1) if args.empty? || args.size != 1
      args.head
    end
  end
end
