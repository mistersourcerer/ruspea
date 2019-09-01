module Ruspea::Runtime
  class Lm
    attr_reader :arity, :params, :body

    def initialize(params: [], body: Nill.instance, closure: Env::Empty.instance)
      @params = params
      @arity = params.length
      @body = body
      @closure = closure
    end

    def call(*args, context: nil, evaler: nil)
      context ||= Env::Empty.instance
      evaler ||= Ruspea::Interpreter::Evaler.new

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
        if args.length != arity
          raise Ruspea::Error::Arity.new(arity, args.length)
        end

        [
          environment = environment_with(args, context, evaler: evaler),
          ->(environment, evaler, args) {
            evaluate(body, context: environment, evaler: evaler)
          }
        ]
      end
    end

    def environment_with(args, context, evaler:)
      env = Env.new(context)
      args.each_with_index.reduce(env) { |env, tuple|
        arg, idx = tuple
        sym =
          if arg.is_a?(Ruspea::Interpreter::Form)
            arg.value
          else
            arg
          end

        env.tap { |e|
          e.define(
            params[idx], evaler.call(sym, context: context))
        }
      }
    end

    def evaluate(forms, result = nil, evaler:, context:)
      return result if forms.empty?

      evaluate(
        forms.tail,
        evaler.call(forms.head, context: context),
        evaler: evaler,
        context: context)
    end
  end
end
