module Ruspea::Runtime
  class EmptyContext
    def define(_, _)
      nil
    end

    def lookup(_)
      nil
    end
  end
end
