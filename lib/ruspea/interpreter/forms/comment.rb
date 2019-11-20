module Ruspea::Interpreter::Forms
  class Comment
    include Ruspea::Interpreter::Form

    def inspect
      "(%_form \"#{self.value}\" #{self.position.inspect} \"#{self.class.name}\")"
    end
  end
end
