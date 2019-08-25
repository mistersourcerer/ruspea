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
        arguments = expression.tail.to_a
        # TODO: raise if ! respond_to?(:call)
        fn.call(*arguments, context: context, evaler: self)
      when Array
        expression.map { |exp|
          call(exp, context: context)
        }
      when TrueClass
        true
      when FalseClass
        false
      else
        raise "Unrecognized expression"
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
  end
end
