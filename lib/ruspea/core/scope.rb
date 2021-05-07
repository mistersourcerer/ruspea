module Ruspea::Core
  class Scope
    include Casting

    def initialize
      @register = {}
    end

    def register_public(instance)
      instance
        .public_methods(false)
        .each { |label| register[Symbol(label)] = instance }
    end

    def defined?(label)
      register.key? Symbol(label)
    end

    private

    attr_reader :register
  end
end
