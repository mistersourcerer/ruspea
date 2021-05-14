module Ruspea::Core
  module Casting
    def Symbol(label)
      Symbol.new(label.to_s)
    end
  end
end
