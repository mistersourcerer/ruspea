module Ruspea
  class Core::Quote
    def call(form, _)
      form.value.head
    end
  end
end
