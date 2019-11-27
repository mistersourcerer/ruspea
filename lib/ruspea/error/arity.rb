module Ruspea
  class Error::Arity < Error::Standard
    def initialize(expected, received, function: nil)
      super message_for(expected, received, function)
    end

    private

    def message_for(expected, received, function)
      if !function.nil?
        return "#{function} expects #{expected} arguments (#{received} were given)."
      end

      "Expected #{expected} args, but received #{received}"
    end
  end
end
