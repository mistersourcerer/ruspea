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

      def around(env)
        env
      end

      def ==(other)
        return true if other.is_a? Empty
        false
      end
    end

    include Ruspea::Error

    def initialize(context = nil, table = nil)
      @table =
        if table.nil?
          {}
        else
          table.dup
        end
      @context = context || Empty.instance

      @fn = Fn.new(fn_define, fn_fetch)
    end

    def define(sym, value)
      @table[sym] = value
    end

    def lookup(sym)
      @table.fetch(sym) { @context.lookup(sym) }
    end

    def call(*args, context: nil, evaler: nil)
      # evaler will always send an array
      # to a #call that is not a #arity
      if args.is_a?(Array) && args.length == 1
        args = args.first
      end
      @fn.call(*args, context: context, evaler: evaler)
    end

    def around(env)
      new_context = env
        .context
        .around(self)

      self.class.new(new_context, env.table)
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
