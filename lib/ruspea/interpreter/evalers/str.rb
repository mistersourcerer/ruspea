module Ruspea::Interpreter::Evalers
  class Str
    def match?(form)
      form.value.is_a? String
    end

    def call(form, _)
      form.value
    end
  end
end
