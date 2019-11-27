module Ruspea
  class Core::Eq
    def initialize
      @evaler = Evaler.new
    end

    def call(form, context)
      check_arity form
      value = form.value
      @evaler.call(value.head, context) ==
        @evaler.call(value.tail.head, context)
    end

    private

    def check_arity(form)
      wrong = form.value.count > 2 || form.value.count <= 1

      if wrong
        raise Error::Arity.new(2, form.value.count, function: "eq")
      end
    end
  end
end
