module Ruspea::Runtime
  class Lm
    attr_reader :arity, :params, :body

    def initialize(params: [], body: [], closure: Env::Empty.instance)
      @params = params
      @arity = params.length
      @body = body
      @closure = closure
    end

    def call(*args, context: nil, evaler: nil)
      context ||= Env::Empty.instance
      evaler ||= ->(exp, *_) { exp }

      env, callable = env_and_callable_body(args, context, evaler)
      env.define Sym.new("%ctx"), context

      callable.call closure.around(env), evaler, args
    end

    private

    attr_reader :closure

    def env_and_callable_body(args, context, evaler)
      if body.respond_to? :call
        [
          environment_with(args, context, evaler: ->(arg, _) { arg }),
          ->(environment, evaler, _) { body.call environment, evaler }
        ]
      else
        [
          environment = environment_with(args, context, evaler: evaler),
          ->(environment, evaler, args) { evaluate_body environment, evaler, args }
        ]
      end
    end

    def environment_with(args, context, evaler:)
      env = Env.new(context)
      args.each_with_index.reduce(env) { |env, tuple|
        arg, idx = tuple

        env.tap { |e|
          e.define params[idx], evaler.call(arg, context: context)
        }
      }
    end

    def evaluate_body(environment, evaler, args)
      if args.length != arity
        raise Ruspea::Error::Arity.new(arity, args.length)
      end

      body.reduce(nil) { |result, expression|
        evaler.call(expression, context: environment)
      }
    end
  end
end
