module Ruspea::Runtime
  class Env
    include Ruspea::Error

    def initialize
      @table = {}
    end

    def define(sym, value)
      @table[sym] = value
    end

    def lookup(sym)
      @table.fetch(sym) { raise Resolution.new(sym) }
    end
  end
end
