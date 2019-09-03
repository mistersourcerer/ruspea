module Ruspea::Interpreter
  class Evaler
    include Ruspea::Runtime
    include Ruspea::Error

    def call(value, context: Env::Empty.instance)
      return call(value.value, context: context) if value.is_a?(Form)

      case value
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
          if fn.respond_to?(:arity)
            if fn.arity == 1 && value.tail.count > 1
              [value.tail]
            else
              value.tail.to_a
            end
          else
            if fn.is_a? Fn
              value.tail.to_a
            else
              [value.tail.to_a]
            end
          end

        fn.call(*arguments, context: context, evaler: self)
      else
        raise "Unrecognized expression"
      end
    end

    private

    def fn_from_invocation(form, context)
      name =
        if form.head.is_a?(Ruspea::Interpreter::Form)
          form.head.value
        else
          form.head
        end
      context
        .lookup(name)
        .tap { |fn|
          raise Resolution.new(name) if fn.nil?
        }
    end
  end
end
