module Ruspea
  class Lisp::Cond
    include Core::Predicates
    include Lisp::Errors
    EVALUATOR = Evaluator.new

    def call(args, env, evaluator: EVALUATOR)
      raise arg_type_error(args) if !list?(args)
      return nil if ! clause = truthy_clause(args, env, evaluator)
      clause.tail.reduce(nil) { |_, expr| evaluator.eval(expr, env) }
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

    def truthy_clause(clauses, env, evaluator)
      find(clauses) { |clause, idx|
        raise non_list_clause_error(idx + 1) if !list?(clause)
        first_expr = evaluator.eval(clause.head, env)
        first_expr != false && first_expr != nil
      }
    end
  end
end
