module Ruspea::Interpreter::Evalers
  class Sym
    def match?(form)
      form.value.is_a? Ruspea::Runtime::Sym
    end

    def call(form, context)
      context.lookup form.value
    end
  end
end
