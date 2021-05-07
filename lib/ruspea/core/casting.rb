module Ruspea::Core
  module Casting
    def Symbol(label)
      return label if label.is_a? Symbol
      Symbol.new label
    end
  end
end
