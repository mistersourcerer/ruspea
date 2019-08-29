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
          env.call(Sym.new("expression"))
        }
      )
    end

    def fn_def
      Lm.new(
        params: [Sym.new("sym"), Sym.new("val")],
        body: ->(env, evaler) {
          caller_context = env.call(Sym.new("%ctx"))
          sym = env.call(Sym.new("sym"))
          value_form = env.call(Sym.new("val"))
          value = evaler.call(value_form, context: env)

          caller_context.call(sym, value)
        }
      )
    end

    def fn_fn
      Lm.new(
        params: [Sym.new("declaration")],
        body: ->(env, evaler) {
          declaration = env.call(Sym.new("declaration"))
          caller_context = env.call(Sym.new("%ctx"))

          params = declaration.head.value.map { |arg| arg.value }
          Lm.new(
            params: params,
            body: declaration.tail,
            closure: caller_context
          )
        }
      )
    end

    def fn_cond
      Lm.new(
        params: [Sym.new("tuples")],
        body: ->(env, evaler) {
          conditions = env.lookup(Sym.new("tuples"))
          raise "NOPE" if conditions.count % 2 != 0

          find_true(conditions, evaler, env)
        }
      )
    end

    def find_true(conditions, evaler, context)
      return nil if conditions.empty?
      found = evaler.call(conditions.head, context: context) == true
      return evaler.call(conditions.tail.head, context: context) if found

      find_true(conditions.tail.tail, evaler, context)
    end
  end
end
