require "singleton"

module Ruspea::Core
  class NilContext
    include Singleton

    def initialize
      @scope = Scope.new
    end

    def defined?(_)
      false
    end

    def resolve(label)
      scope[label]
    end

    alias_method :[], :resolve

    def []=(_, _)
      nil
    end

    protected

    attr_reader :scope
  end
end
