module Ruspea::Interpreter::Evalers
  class Num
    def match?(form)
      form.value.is_a? Numeric
    end

    def call(form, _)
      form.value
    end
  end
end
