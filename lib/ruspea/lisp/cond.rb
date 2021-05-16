module Ruspea
  class Lisp::Cond
    include Core::Predicates
    include Lisp::Errors

    def call(args, ctx)
      raise arg_type_error(args) if !list?(args)
      return nil if ! clause = truthy_clause(args, ctx)
      clause.tail.reduce(nil) { |_, expr| ctx.eval(expr) }
    end

    private

    def non_list_clause_error(position)
      Error::Execution.new <<~ERR
        A non-list clause was found in position: #{position}
      ERR
    end

    def find(list, counter = 0, &blk)
      return nil if list.empty?
      return list.head if yield(list.head, counter)
      find(list.tail, counter + 1, &blk)
    end

    def truthy_clause(clauses, ctx)
      find(clauses) { |clause, idx|
        raise non_list_clause_error(idx + 1) if !list?(clause)
        first_expr = ctx.eval(clause.head)
        first_expr != false && first_expr != nil
      }
    end
  end
end
