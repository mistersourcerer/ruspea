module Ruspea::Language
  class Core < Ruspea::Runtime::Env
    include Ruspea::Runtime

    def initialize(*args)
      super(*args)

      define Sym.new("quote"), fn_quote
      define Sym.new("def"), fn_def
      define Sym.new("fn"), fn_fn
      define Sym.new("cond"), fn_cond
    end

    private

    def fn_quote
      Lm.new(
        params: [Sym.new("expression")],
        body: ->(env, _) {
          env.call Sym.new("expression")
        }
      )
    end

    def fn_def
      Lm.new(
        params: [Sym.new("sym"), Sym.new("val")],
        body: ->(env, evaler) {
          caller_context = env.call(Sym.new("%ctx"))
          sym = env.call(Sym.new("sym"))
          expression = env.call(Sym.new("val"))
          value = evaler.call(expression, context: env)

          caller_context.call(sym, value)
        }
      )
    end

    def fn_fn
      Lm.new(
        params: [Sym.new("params"), Sym.new("body")],
        body: ->(env, evaler) {
          params = env.call(Sym.new("params"))
          body = env.call(Sym.new("body"))
          caller_context = env.call(Sym.new("%ctx"))

          Lm.new(
            params: params,
            body: body.to_a,
            closure: caller_context
          )
        }
      )
    end

    def fn_cond
      Lm.new(
        params: [Sym.new("tuples")],
        body: ->(env, evaler) {
          tuples = env.lookup(Sym.new("tuples"))
          tuple = tuples.find(->{ [nil, nil] }) { |test, _|
            evaler.call(test, context: env)
          }
          evaler.call(tuple[1], context: env)
        }
      )
    end
  end
end
