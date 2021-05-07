module Ruspea::Core
  class Scope
    include Casting

    def initialize
      @bindings = {}
    end

    def register_public(instance)
      instance
        .public_methods(false)
        .each { |label| bindings[Symbol(label)] = instance }
    end

    def defined?(label)
      bindings.key? Symbol(label)
    end

    def resolve(label)
      raise not_defined(label) if !self.defined?(label)

      bindings[Symbol(label)]
    end

    def register(label, object)
      bindings[Symbol(label)] = object
    end

    private

    attr_reader :bindings

    def not_defined(label)
      Ruspea::Error::Execution.new("Unable to resolve symbol #{label}")
    end
  end
end
