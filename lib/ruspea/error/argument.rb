module Ruspea
  class Error::Argument < Error::Standard
    def initialize(type_expected, received, function: nil)
      super message_for(type_expected, received, function)
    end

    private

    def message_for(expected, received, function)
      if !function.nil?
        return "#{function} expects #{expected} but #{received} is a #{received.class})."
      end

      "Expects #{expected} but received #{received.class}"
    end
  end
end
