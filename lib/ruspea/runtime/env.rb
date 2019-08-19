require "singleton"

module Ruspea::Runtime
  class Env
    class Empty
      include Singleton

      def define(_, _)
        nil
      end

      def lookup(_)
        nil
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

    def initialize(context = nil)
      @table = {}
      @context = context || Empty.instance

      @fn = Fn.new(fn_define, fn_fetch)
    end

    def define(sym, value)
      @table[sym] = value
    end

    def lookup(sym)
      @table.fetch(sym) { @context.lookup(sym) || raise(Resolution.new(sym)) }
    end

    def call(*args)
      @fn.call(*args)
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

    protected

    attr_accessor :table, :context

    private

    def fn_define
      @fn_define ||= Lm.new(
        params: [Sym.new("sym"), Sym.new("val")],
        body: ->(env, _) {
          define(
            env.lookup(Sym.new("sym")),
            env.lookup(Sym.new("val"))
          )
        }
      )
    end

    def fn_fetch
      @fn_fetch ||= Lm.new(
        params: [Sym.new("sym")],
        body: ->(env, _) {
          lookup env.lookup(Sym.new("sym"))
        }
      )
    end
  end
end
