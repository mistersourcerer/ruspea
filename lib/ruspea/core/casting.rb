require "immutable/list"
require "immutable/hash"

module Ruspea
  module Core::Casting
    include Core::Predicates

    def Symbol(label)
      Core::Symbol.new(label.to_s)
    end

    def List(*elements)
      Immutable::List[*elements]
    end

    def Scope(thing)
      return thing if thing.is_a?(Immutable::Hash)

      thing = Hash[thing] if !thing.is_a?(Hash)
      if thing.keys.any? { |k| !sym?(k) }
        thing = Hash[thing.map { |k, v| [Symbol(k), v] }]
      end
      Immutable::Hash.new(Hash[thing])
    end
  end
end
