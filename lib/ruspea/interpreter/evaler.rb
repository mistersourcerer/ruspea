module Ruspea::Interpreter
  class Evaler
    include Ruspea::Runtime
    include Ruspea::Error

    def call(expression, context: Env::Empty.instance)
      case expression
      when Numeric
        expression
      when String
        expression
      when Sym
        context.lookup expression
      when List
        fn = fn_from_invocation(expression, context)
        arguments = args_from_invocation(expression, context)
        # TODO: raise if ! respond_to?(:call)
        fn.call(*arguments, context: context, evaler: self)
      else
        raise
      end
    end

    private

    def fn_from_invocation(expression, context)
      context
        .lookup(expression.head)
        .tap { |fn|
          raise Resolution.new(expression.head) if fn.nil?
        }
    end

    def args_from_invocation(expression, context)
      expression
        .tail
        .to_a
    end
  end
end
