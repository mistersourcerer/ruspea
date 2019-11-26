module Ruspea
  class Core::Quote
    def initialize
      @pos = Position.new(0, 0)
    end

    def call(form)
      form.value.head
    end
  end
end
