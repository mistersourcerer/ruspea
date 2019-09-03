module Ruspea::Language
  class Core < Ruspea::Runtime::Env
    include Ruspea::Runtime

    def initialize(*args)
      super(*args)

      @ruby = Ruby.new

      define Sym.new("quote"), fn_quote
      define Sym.new("def"), fn_def
      define Sym.new("fn"), fn_fn
      define Sym.new("cond"), fn_cond

      define Sym.new("::"), fn_constantize
      define Sym.new("."), fn_dot
      define Sym.new("eval"), fn_eval

      load_standard
    end

    private

    attr_reader :ruby

    def load_standard
      reader = Ruspea::Interpreter::Reader.new
      evaler = Ruspea::Interpreter::Evaler.new
      Dir.glob(
        Ruspea.root.join("language/*.rsp").to_s
      ).each do |file|
        _, forms = reader.call(
          File.read(file))
        evaler.call(forms, context: self)
      end
    end

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
          find_true(conditions, evaler, env)
        }
      )
    end

    def find_true(conditions, evaler, context)
      return nil if conditions.empty?
      tuple = conditions.head.value

      raise "NOPE: what is the expression?" if tuple.tail.empty?

      if evaler.call(tuple.head, context: context) == true
        tuple.tail.to_a.reduce(nil) { |result, form|
          evaler.call(form, context: context)
        }
      else
        find_true(conditions.tail, evaler, context)
      end
    end

    def fn_dot
      Lm.new(
        params: [Sym.new("path")],
        body: ->(env, evaler) {
          context = env.lookup(Sym.new("%ctx"))
          path = env.lookup(Sym.new("path"))

          target =
            begin
              evaler.call(path.head, context: context)
            rescue Ruspea::Error::Resolution
              # if form is a symbol not solvable in the current context,
              # then we use it as the name of the "contantizable" thing.
              path.head.value.to_s
            end

          method = path.tail.head.value.to_s

          has_args = !path.tail.tail.empty?
          if has_args
            args = path.tail.tail
              .to_a
              .map { |form|
                evaler.call(form, context: context) }
            target.send(method, *args)
          else
            target.send(method)
          end
        }
      )
    end

    def fn_constantize
      Lm.new(
        params: [Sym.new("path")],
        body: ->(env, evaler) {
          path = env.lookup(Sym.new("path"))
          Array(path)
            .map { |target| target.to_s }
            .reduce(nil) { |value, component|
              value = ruby.constantize(component)
            }
        }
      )
    end

    def fn_eval
      fn = Fn.new

      fn.add(
        Lm.new(
          params: [Sym.new("forms")],
          body: ->(env, evaler) {
            forms = evaler.call(
              env.lookup(Sym.new("forms")), context: env)
            forms.reduce(nil) { |_, form|
              evaler.call(form, context: env)
            }
          }
        )
      )

      fn.add(
        Lm.new(
          params: [Sym.new("forms"), Sym.new("context")],
          body: ->(env, evaler) {
            context = evaler.call(
                env.lookup(Sym.new("context")), context: env)

            forms = evaler.call(
              env.lookup(Sym.new("forms")), context: env)

            forms.reduce(nil) { |_, form|
              evaler.call(form, context: context)
            }
          }
        )
      )

      fn
    end
  end
end
