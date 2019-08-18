module Ruspea::Runtime
  class Lm
    attr_reader :arity

    def initialize(params: [], body: [], evaler: ->(exp, *_) { exp })
      @params = params
      @arity = params.length
      @body = body
      @evaler = evaler
    end

    def call(*args, context: Env::Empty.instance)
      environment = environment_with(args, context)
      environment.define Sym.new("%ctx"), context

      if body.respond_to? :call
        return body.call environment, context, evaler
      end

      evaluate_body args, environment
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

    def evaluate_body(args, environment)
      if args.length != arity
        raise Ruspea::Error::Arity.new(arity, args.length)
      end

      body.reduce(nil) { |result, expression|
        result = evaler.call(
          expression,
          context: environment)
      }
    end
  end
end
