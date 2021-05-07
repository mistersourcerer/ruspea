module Ruspea
  class Evaler
    def initialize
      @primitives = Primitives.new(self)
    end

    def eval(expr)
      return expr if atom?(expr)
      return list(expr) if list?(expr)

      raise "Invalid Expression"
    end

    def atom?(expr)
      expr.is_a?(Numeric) ||
        expr.is_a?(String) ||
        expr.is_a?(TrueClass) || expr.is_a?(FalseClass) ||
        sym?(expr) ||
        expr == DS::Nill.instance
    end

    def list?(expr)
      expr.is_a?(DS::List) || expr.is_a?(DS::Nill)
    end

    def value_of(list)
      return DS::Nill.instance if list.empty?

      value = self.eval(list.head)
      return value if list.tail.empty?

      value_of(list.tail)
    end

    private

    def sym?(expr)
      expr.is_a?(Core::Symbol)
    end

    def list(expr)
      operand = String(expr.head)
      args = expr.tail

      return @primitives.public_send(operand, args) if @primitives.knows?(operand)
      raise "#{operand} is not a function"
    end
  end

  class Primitives
    def initialize(evaler)
      @evaler = evaler
    end

    def knows?(operand)
      respond_to?(operand)
    end

    def quote(arg)
      raise args_error(1, arg.count) if arg.count > 1
      arg.head
    end

    def atom(arg)
      raise args_error(1, arg.count) if arg.count > 1
      @evaler.atom?(arg.head)
    end

    def eq(arg)
      raise args_error(2, arg.count) if arg.count > 2
      raise args_error(2, arg.count) if arg.count == 1

      left, right = *arg
      return false unless @evaler.atom?(left) && @evaler.atom?(right)

      left == right
    end

    def car(arg)
      raise args_error(1, arg.count) if arg.count > 1

      list = @evaler.eval(arg.head)
      raise arg_type("list", list.class) if !@evaler.list?(list)

      list.head
    end

    def cdr(arg)
      raise args_error(1, arg.count) if arg.count > 1

      list = @evaler.eval(arg.head)
      raise arg_type("list", list.class) if !@evaler.list?(list)

      list.tail
    end

    def cons(arg)
      raise args_error(2, arg.count) if arg.count > 2
      raise args_error(2, arg.count) if arg.count == 1

      head, tail = @evaler.eval(arg.head), @evaler.eval(arg.tail.head)
      raise arg_type("list", tail.class) if !@evaler.list?(tail)

      tail.cons(head)
    end

    def cond(arg)
      return DS::Nill.instance if arg.empty?
      check_clause(arg, 1)
    end

    private

    def check_clause(clauses, clause_number)
      raise non_list_clause(clauses.head) if !@evaler.list?(clauses.head)

      condition = clauses.head.head
      to_eval = clauses.head.tail
      current_value = @evaler.eval(condition)

      if !current_value
        return DS::Nill.instance if clauses.tail.empty?
        return check_clause(clauses.tail, clause_number + 1)
      end

      return current_value if to_eval.empty?

      @evaler.value_of(to_eval)
    end

    def args_error(expected, given)
      Error::Syntax.new <<~ER
        Wrong number of args for #{caller_locations.first.label}, 
        expected #{expected} but #{given} given
      ER
    end

    def arg_type(expected, given)
      Error::Execution.new <<~ER
        Wrong argument type for #{caller_locations.first.label}, 
        expected #{expected} but #{given} given
      ER
    end

    def non_list_clause(given)
      Error::Execution.new "Clause #{given} should be a List"
    end
  end
end
