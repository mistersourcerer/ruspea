require "immutable/hash"
require "ruspea/core/symbol"

module Ruspea::Core
  class Environment
    include Casting

    def initialize
      @context = Immutable::Hash.new
    end

    def []=(label, value)
      @context = @context.put(Symbol(label), value)
    end

    def [](label)
      raise unbounded_error(label) if !bound?(label)
      @context.get(Symbol(label))
    end

    def bound?(label)
      @context.include? Symbol(label)
    end

    private

    def unbounded_error(label)
      Ruspea::Error::Execution.new <<~ERR
        Unable to resolve symbol: #{label} in this context
      ERR
    end
  end
end
