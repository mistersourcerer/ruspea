module Ruspea::Interpreter
  class Evaler
    include Ruspea::Runtime
    include Ruspea::Error

    def call(form, context: Env::Empty.instance)
      case value = form.value
      when Sym
        context.lookup value
      when Numeric
        value
      when String
        value
      when NilClass
        nil
      when TrueClass
        true
      when FalseClass
        false
      when Array
        value.map { |f|
          call(f, context: context)
        }
      when List
        fn = fn_from_invocation(value, context)
        # TODO: raise if ! respond_to?(:call)

        arguments =
          if fn.arity == 1 && value.tail.count > 1
            [value.tail]
          else
            value.tail.to_a
          end

        fn.call(*arguments, context: context, evaler: self)
      else
        raise "Unrecognized expression"
      end
    end

    private

    def fn_from_invocation(form, context)
      name = form.head.value
      context
        .lookup(name)
        .tap { |fn|
          raise Resolution.new(name) if fn.nil?
        }
    end
  end
end
