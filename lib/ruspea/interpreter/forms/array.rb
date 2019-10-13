module Ruspea::Interpreter::Forms
  class Array
    ARRAY_OPEN = /\A\[/
    ARRAY_CLOSE = /\A\]/

    def initialize
      @reader = Ruspea::Interpreter::Reader.new
    end

    def match?(char)
      ARRAY_OPEN.match? char
    end

    def read(code)
      rest = code.tail
      forms = []
      closed = false

      if match?(code.head)
        while(!rest.empty?)
          if finished?(rest)
            rest = rest.tail
            closed = true
            break
          end

          rest, new_form = @reader.next_form(rest)
          forms = forms + [new_form] if !new_form.nil?
        end
      end

      evaler = method(:eval)
      [
        rest,
        Ruspea::Interpreter::Form.new(forms, closed: closed, evaler: evaler)]
    end

    private

    def finished?(code)
      ARRAY_CLOSE.match?(code.head)
    end

    def eval(array, context, evaler)
      array.map { |f|
        evaler.call f, context: context
      }
    end
  end
end
