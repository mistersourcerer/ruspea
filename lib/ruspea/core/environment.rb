require "immutable/hash"
require "immutable/deque"

module Ruspea
  class Core::Environment
    include Core::Casting

    STACK_ENGINE = Immutable::Deque.new
    SCOPE_ENGINE = Immutable::Hash.new
    EMPTY_SCOPE = Immutable::Hash.new

    def initialize(lookup: STACK_ENGINE, new_scope: SCOPE_ENGINE)
      @lookup = lookup.push(Scope(new_scope))
    end
    NIL_ENV = new

    def push(scope = nil)
      if scope.is_a?(self.class)
        return self.class.new(lookup: @lookup, new_scope: scope.lookup.last)
      end

      scope = Scope(scope) if !scope.nil?
      scope ||= EMPTY_SCOPE
      self.class.new(lookup: @lookup, new_scope: scope)
    end

    def pop
      new_lookup = @lookup.pop
      if new_lookup.empty?
        NIL_ENV
      else
        self.class.new(lookup: new_lookup)
      end
    end

    def []=(label, value)
      scope = @lookup.last
      @lookup = @lookup.pop.push(scope.put(Symbol(label), value))
      self
    end

    def [](label)
      raise unbound_error(label) if !bound?(label)
      find(Symbol(label), @lookup)
    end

    def empty?(to_lookup = nil)
      to_lookup ||= @lookup
      return true if to_lookup.size == 0
      return false if !to_lookup.last.empty?
      empty?(to_lookup.pop)
    end

    def bound?(label, to_lookup = nil)
      to_lookup ||= @lookup
      return false if to_lookup.empty?
      return true if to_lookup.last.key?(Symbol(label))
      bound?(label, to_lookup.pop)
    end

    protected

    attr_reader :lookup

    private

    def find(label, to_lookup)
      return EMPTY_SCOPE[label] if to_lookup.empty?
      return to_lookup.last.get(Symbol(label)) if to_lookup.last.key?(Symbol(label))
      find(label, to_lookup.pop)
    end

    def unbound_error(label)
      Error::Execution.new <<~ERR
        Unable to resolve the symbol #{label} in this context
      ERR
    end
  end
end
