module Ruspea::Interpreter::Evalers
  class Bool
    def match?(form)
      form.value.is_a?(TrueClass) ||
        form.value.is_a?(FalseClass)
    end

    def call(form, _)
      return true if form.value.is_a?(TrueClass)

      false
    end
  end
end
