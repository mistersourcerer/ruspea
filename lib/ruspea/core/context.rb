require "forwardable"

module Ruspea::Core
  # A context is created when a script runs.
  # This is the Global context.
  #
  # When functions are invoked
  # new contexts are created so we can have closures
  # and all that good stuff.
  #
  # That means a context can have it's own scope
  # but also knows how to delegate symbol lookup
  # to "outer" contexts.
  #
  # PS.: This is not a documentation,
  # this is just an interim breadcrumb type of situation
  # for the author himself.
  class Context
    NIL_CONTEXT = new

    extend Forwardable
    def_delegators :@scope, :[]=

    def initialize(scope = Scope.new, fallback = NIL_CONTEXT)
      @scope = scope
      @fallback = fallback
      yield(self) if block_given?
    end

    # Reimplement this with the "outer ctx" lookup
    def defined?(label)
      scope.defined?(label) || fallback?(label)
    end

    # Reimplement this with the "outer ctx" lookup
    def resolve(label)
      # Maybe raise if !defined?(label) ?
      return scope[label] if scope.defined?(label)
      fallback[label]
    end

    alias_method :[], :resolve

    def around(other_ctx)
      self.class.new other_ctx.scope, self
    end

    protected

    attr_reader :scope

    private

    attr_reader :fallback

    def fallback?(label)
      !fallback.nil? && fallback.defined?(label)
    end
  end
end
