module Ruspea::Core
  class Quote
    def initialize
      @pos = Ruspea::Interpreter::Position.new(0, 0)
    end

    def call(form)
      form.head
    end
  end
end
