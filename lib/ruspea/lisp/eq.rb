module Ruspea
  class Lisp::Eq
    include Core::Predicates
    include Lisp::Errors

    def call(args, _)
      raise arg_type_error(args) if !list?(args)
      check_args(args, 2)
      lhs, rhs = args.head, args.tail.head
      return lhs == rhs if comparable?(lhs, rhs)
      return true if empty_list?(lhs, rhs)
      false
    end

    private

    def comparable?(lhs, rhs)
      sym?(lhs, rhs) || numeric?(lhs, rhs) || bool?(lhs, rhs)
    end

    def empty_list?(lhs, rhs)
      list?(lhs, rhs) && lhs.empty? && rhs.empty?
    end
  end
end
