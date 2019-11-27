module Ruspea
  class Core::Rest
    def initialize
      @evaler = Evaler.new
    end

    def call(form, context)
      list_form = @evaler.call(form.value.head, context)
      check_arguments list_form
      list_form.value.tail
    end

    def check_arguments(list_form)
      if !list_form.is_a?(Forms::List)
        raise Error::Argument.new(Runtime::List, list_form, function: "rest")
      end
    end
  end
end
