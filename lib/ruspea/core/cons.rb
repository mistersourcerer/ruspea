module Ruspea
  class Core::Cons
    def initialize
      @evaler = Evaler.new
    end

    def call(form, context)
      check_arguments form
      result = @evaler.call(form.value.tail.head, context)
      tail = result.is_a?(Forms::List) ? result.value : result
      if !tail.is_a?(Runtime::List) && !tail.is_a?(Runtime::Nil)
        raise Error::Argument.new(Runtime::List, tail, function: "cons")
      end

      head = @evaler.call(form.value.head, context)
      tail.cons(head)
    end

    private

    def check_arguments(form)
      if !form.is_a?(Forms::List)
        raise Error::Argument.new
      end

      if form.value.count != 2
        raise Error::Arity.new(2, form.value.count, function: "cons")
      end
    end
  end
end
