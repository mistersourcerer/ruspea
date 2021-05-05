module Ruspea
  class Evaler
    def initialize
      @primitives = Primitives.new(self)
    end

    def eval(expr)
      # return sym(expr) if sym?(expr)
      return expr if expr.is_a?(String)
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

    private

    def sym?(expr)
      expr.is_a?(Prim::Sym)
    end

    def list(expr)
      operand = String(expr.head)
      args = expr.tail

      @primitives.public_send(operand, args) if @primitives.knows?(operand)
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

    private

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
  end
end
