module Ruspea
  class Core::Atom
    def initialize
      @evaler = Evaler.new
    end

    def call(form, context)
      result = @evaler.call(form.value.head, context)
      return true if nill?(result)

      case result
      when Integer, String, Symbol
        true
      else
        false
      end
    end

    private

    def nill?(result)
      result.class.include?(Form) &&
        result.value.is_a?(Runtime::Nill)
    end
  end
end
