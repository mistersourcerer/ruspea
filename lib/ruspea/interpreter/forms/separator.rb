module Ruspea::Interpreter::Forms
  class Separator
    SEPARATOR = /\A[,\s]/

    def match?(char)
      SEPARATOR.match? char
    end

    def call(code)
      return [code, nil] if finished?(code)

      call(code.tail)
    end

    private

    def finished?(code)
      code.empty? || !match?(code.head)
    end
  end
end
