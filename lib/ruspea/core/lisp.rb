module Ruspea::Core
  class Lisp
    def quote(arg)
      raise args_error(1, arg.count) if arg.count > 1
      arg.head
    end

    def atom(arg)
      raise args_error(1, arg.count) if arg.count > 1
      atom?(arg.head)
    end

    def eq(arg)
      raise args_error(2, arg.count) if arg.count > 2
      raise args_error(2, arg.count) if arg.count == 1

      left, right = *arg
      return false unless atom?(left) && atom?(right)

      left == right
    end

    def car(arg)
      raise args_error(1, arg.count) if arg.count > 1

      list = yield(arg.head)
      raise arg_type("list", list.class) if !list?(list)

      list.head
    end

    def cdr(arg)
      raise args_error(1, arg.count) if arg.count > 1

      list = yield(arg.head)
      raise arg_type("list", list.class) if !list?(list)

      list.tail
    end

    def cons(arg)
      raise args_error(2, arg.count) if arg.count > 2
      raise args_error(2, arg.count) if arg.count == 1

      head, tail = yield(arg.head), yield(arg.tail.head)
      raise arg_type("list", tail.class) if !list?(tail)

      tail.cons(head)
    end

    def cond(arg, &evaler)
      return Nill.instance if arg.empty?
      check_clause(arg, 1, &evaler)
    end

    private

    def atom?(expr)
      expr.is_a?(Numeric) ||
        expr.is_a?(String) ||
        expr.is_a?(TrueClass) || expr.is_a?(FalseClass) ||
        expr == Nill.instance ||
        expr.is_a?(Symbol)
    end

    def list?(expr)
      expr.is_a?(List) || expr.is_a?(Nill)
    end

    def check_clause(clauses, clause_number, &evaler)
      raise non_list_clause(clauses.head) if !list?(clauses.head)

      condition = clauses.head.head
      to_eval = clauses.head.tail
      current_value = evaler.call(condition)

      if !current_value
        return Nill.instance if clauses.tail.empty?
        return check_clause(clauses.tail, clause_number + 1, &evaler)
      end

      return current_value if to_eval.empty?

      value_of(to_eval, &evaler)
    end

    def value_of(list, &evaler)
      return Nill.instance if list.empty?

      value = evaler.call(list.head)
      return value if list.tail.empty?

      value_of(list.tail, &evaler)
    end

    def args_error(expected, given)
      Ruspea::Error::Execution.new <<~ER
        Wrong number of args for #{caller_locations.first.label}, 
        expected #{expected} but #{given} given
      ER
    end

    def arg_type(expected, given)
      Ruspea::Error::Execution.new <<~ER
        Wrong argument type for #{caller_locations.first.label}, 
        expected #{expected} but #{given} given
      ER
    end

    def non_list_clause(given)
      Ruspea::Error::Execution.new "Clause #{given} should be a List"
    end
  end
end
