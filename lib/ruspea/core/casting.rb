require "immutable/list"

module Ruspea::Core
  module Casting
    def Symbol(label)
      Symbol.new(label.to_s)
    end

    def List(*elements)
      Immutable::List[*elements]
    end
  end
end
