module Ruspea::Runtime
  class Lm
    def initialize(params: [], body: [], evaler: ->(exp, *_) { exp })
      @params = params
      @body = body
      @evaler = evaler
    end

    def call(*args, context: nil)
      if body.respond_to? :call
        return body.call environment_with(args, context), context, evaler
      end

      body.reduce(nil) { |result, expression|
        result = evaler.call(
          expression,
          context: environment_with(args, context))
      }
    end

    private

    attr_reader :params, :body, :evaler

    def environment_with(args, context)
      args.each_with_index.reduce(Env.new(context)) { |env, tuple|
        arg, idx = tuple
        env.tap { |e|
          e.define params[idx], arg
        }
      }
    end
  end
end
