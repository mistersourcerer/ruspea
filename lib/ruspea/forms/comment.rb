module Ruspea::Forms
  class Comment
    include Ruspea::Form

    def inspect
      "(%_form \"#{self.value}\" #{self.position.inspect} \"#{self.class.name}\")"
    end
  end
end
