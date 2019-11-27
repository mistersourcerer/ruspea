module Ruspea
  class Core::First
    def initialize
      @evaler = Evaler.new
    end

    def call(form, context)
      list_form = @evaler.call(form.value.head, context)
      check_arguments list_form
      list_form.value.head
    end

    private

    def check_arguments(list_form)
      if !list_form.is_a?(Forms::List)
        raise Error::Argument.new(Runtime::List, list_form, function: "first")
      end
    end
  end
end
