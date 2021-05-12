module Ruspea::Core
  class Scope
    include Casting

    def initialize
      # TODO: use an immutable Hash here
      @bindings = {}
    end

    def defined?(label)
      bindings.key? Symbol(label)
    end

    def resolve(label, &blk)
      return bindings.fetch(label, &blk) if block_given?
      raise not_defined(label) if !self.defined?(label)

      bindings[Symbol(label)]
    end

    def register(label, object)
      bindings[Symbol(label)] = object
      self
    end

    def register_public(instance)
      instance
        .public_methods(false)
        .each { |label| register label, instance }
      self
    end

    def [](label, &blk)
      resolve(label, &blk)
    end

    def []=(label, object)
      register label, object
    end

    private

    attr_reader :bindings

    def not_defined(label)
      Ruspea::Error::Execution.new("Unable to resolve symbol #{label}")
    end
  end
end
