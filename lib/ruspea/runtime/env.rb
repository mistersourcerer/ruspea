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

      def []=(sym, value)
        define(sym, value)
      end

      def lookup(sym, &not_found)
        resolution_error = Resolution.new(sym)
        if !not_found.nil?
          not_found.call sym, resolution_error
        else
          raise resolution_error
        end
      end

      def [](sym, &not_found)
        lookup(sym, &not_found)
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

    def lookup(sym, &not_found)
      @table.fetch(sym) { @context[sym, &not_found] }
    end

    def fallback(env)
      _current_context = @context
      # TODO: the "correct" implementation of this specific piece
      # would be to "cascade" the current context, meaning:
      #   if env has already a context,
      #   then env.context.context = _current_context.
      # BUT if env.context.context already exists... then
      #   env.context.context.context = _current_context
      # Until we find the "root" context.
      env.context = _current_context
      @context = env
    end

    def [](sym, &not_found)
      lookup(sym, &not_found)
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
