require "singleton"

module Ruspea::Runtime
  class Env
    class Empty
      include Ruspea::Error
      include Singleton

      def initialize(*_)
      end

      def define(*_)
        nil
      end

      def lookup(sym)
        raise(Resolution.new(sym))
      end

      def eql?(other)
        self == other
      end

      def ==(other)
        return true if other.is_a? Empty
        false
      end
    end

    include Ruspea::Error

    def initialize(context = nil, table: nil)
      @table =
        if table.nil?
          {}
        else
          table.dup
        end

      @context = context || Empty.instance
    end

    def define(sym, value)
      @table[sym] = value
    end

    def []=(sym, value)
      define(sym, value)
    end

    def lookup(sym)
      @table.fetch(sym) { @context.lookup(sym) }
    end

    def [](sym)
      lookup(sym)
    end

    def eql?(other)
      self == other
    end

    def ==(other)
      return false if self.class != other.class

      @table == other.table && @context == other.context
    end

    def hash
      @table.hash + @context.hash + :rsp_env.hash
    end

    def inspect
      @table.map { |k, v|
        "#{k} => #{v}"
      }
    end

    protected

    attr_accessor :table, :context
  end
end
