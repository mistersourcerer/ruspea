module Ruspea::Interpreter::Evalers
  class Nill
    def match?(form)
      form.value.nil?
    end

    def call(_, _)
      nil
    end
  end
end
