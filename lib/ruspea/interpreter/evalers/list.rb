module Ruspea::Interpreter::Evalers
  class List
    def match?(form)
      form.value.is_a? Ruspea::Runtime::List
    end

    def call(form, context, evaler)
      list = form.value
      fn = context[list.head.value]

      fn.call(*list.tail.to_a, context: context)
    end
  end
end
