module Ruspea
  class Evaler
    def initialize
      @primitives = Primitives.new
    end

    def eval(expr)
      return list(expr) if expr.is_a?(DS::List)

      raise "Invalid Expression"
    end

    private

    def list(expr)
      operand = expr.head
      args = expr.tail

      @primitives.public_send(operand, args) if @primitives.knows?(operand)
    end
  end

  class Primitives
    def knows?(operand)
      respond_to?(operand)
    end

    def quote(arg)
      raise args_error(1, arg.count) if arg.count > 1
      arg.head
    end

    private

    def args_error(expected, given)
      Error::Syntax.new <<~ER
        Wrong number of args, expected #{expected} but #{given} given
      ER
    end
  end
end
