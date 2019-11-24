module Ruspea::Core
  class Atom
    def call(form)
      !form.nil? ||
        !form.is_a?(Ruspea::Interpreter::Forms::List)
    end
  end
end
