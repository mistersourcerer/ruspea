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
    extend Forwardable
    def_delegator :@scope, :[], :[]=

    def initialize(scope = nil)
      @scope = scope || Scope.new
    end

    # Reimplement this with the "outer ctx" lookup
    def defined?(label)
      scope.defined? label
    end

    # Reimplement this with the "outer ctx" lookup
    def resolve(label)
      scope.resolve label
    end

    private

    attr_reader :scope
  end
end
