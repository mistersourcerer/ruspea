module Ruspea::Interpreter
  class Evaler
    include Ruspea::Runtime
    include Ruspea::Error

    EVALERS = [
      Evalers::List.new,
    ]

    def call(forms, context: Env::Empty.instance)
      Array(forms).reduce(nil) { |result, form|
        if form.respond_to?(:evaler) && !form.evaler.nil?
          form.eval(context, self)
        else
          if evaler = EVALERS.find { |evaler| evaler.match?(form) }
            evaler.call(form, context, self)
          else
            raise "not implemented"
          end
        end
      }

      # value = form.value

      # case value
      # when List
      #   fn = fn_from_invocation(value, context)
      #   # TODO: raise if ! respond_to?(:call)

      #   arguments =
      #     if fn.respond_to?(:arity)
      #       if fn.arity == 1 && value.tail.count > 1
      #         [value.tail]
      #       else
      #         value.tail.to_a
      #       end
      #     else
      #       if fn.is_a? Fn
      #         value.tail.to_a
      #       else
      #         [value.tail.to_a]
      #       end
      #     end

      #   fn.call(*arguments, context: context, evaler: self)
      # else
      #   raise "Unrecognized expression"
      # end
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
