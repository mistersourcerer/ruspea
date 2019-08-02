module Ruspea::Runtime
  class Fn
    def initialize(body = [], params: [], context: nil)
      @body = body
      @params = params
      @evaler = Ruspea::Evaler::Eval.new
      @context = context
    end

    def call(*args)
      env = Env.new(@context)
      @params.each_with_index { |sym, idx|
        env.define sym, args[idx]
      }

      @body.reduce(nil) { |result, expression|
        @evaler.call(expression, env: env)
      }
    end

    def eql?(other)
      self == other
    end

    def ==(other)
      return false if self.class != other.class
      @params == other.params &&
        @body == other.body
    end

    def hash
      @params.hash + @body.hash + :rsp_fn.hash
    end

    protected

    attr_reader :params, :body
  end
end
