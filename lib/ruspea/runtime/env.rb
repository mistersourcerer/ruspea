module Ruspea::Runtime
  class Env
    include Ruspea::Error

    def initialize(context = nil)
      @table = {}
      @context = context || EmptyContext.new
    end

    def define(sym, value)
      @table[sym] = value
    end

    def lookup(sym)
      @table.fetch(sym) { @context.lookup(sym) || raise(Resolution.new(sym)) }
    end
  end
end
