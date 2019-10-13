module Ruspea::Interpreter::Forms
  class List
    LIST_OPEN = /\A\(/
    LIST_CLOSE = /\A\)/

    def initialize
      @reader = Ruspea::Interpreter::Reader.new
    end

    def match?(char)
      LIST_OPEN.match? char
    end

    def read(code)
      rest = code.tail
      forms = []
      meta = {closed: false}

      if match?(code.head)
        while(!rest.empty?)
          rest, new_form = @reader.next_form(rest)
          forms = forms + [new_form] if !new_form.nil?

          if finished?(rest)
            rest = rest.tail
            meta = {closed: true}
            break
          end
        end
      end

      list = Ruspea::Runtime::List.create(*forms)
      [rest, Ruspea::Interpreter::Form.new(list, meta)]
    end

    private

    def finished?(code)
      LIST_CLOSE.match?(code.head)
    end
  end
end
