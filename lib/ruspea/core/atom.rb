module Ruspea
  class Core::Atom
    def initialize
      @evaler = Evaler.new
    end

    def call(form, context)
      return false if form.value.count > 1

      puts "atom? #{form.value.head}(#{form.value.head.class})"
      case @evaler.call(form.value.head, context)
      when Integer, String, Symbol, Runtime::Nill.instance
        true
      else
        false
      end
    end
  end
end
