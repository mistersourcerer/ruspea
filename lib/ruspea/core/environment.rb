require "immutable/hash"
require "ruspea/core/symbol"

module Ruspea::Core
  class Environment
    include Casting

    def initialize
      @bindings = Immutable::Hash.new
    end

    def []=(label, value)
      @bindings = @bindings.put(Symbol(label), value)
    end

    def [](label)
      raise unbounded_error(label) if !bound?(label)
      @bindings.get(Symbol(label))
    end

    def bound?(label)
      @bindings.include? Symbol(label)
    end

    private

    def unbounded_error(label)
      Ruspea::Error::Execution.new <<~ERR
        Unable to resolve symbol: #{label} in this context
      ERR
    end
  end
end
