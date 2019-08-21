module Ruspea::Language
  class Core < Ruspea::Runtime::Env
    include Ruspea::Runtime

    def initialize
      super

      define Sym.new("quote"), fn_quote
      define Sym.new("def"), fn_def
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
  end
end