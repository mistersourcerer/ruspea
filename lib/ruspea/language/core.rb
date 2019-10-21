module Ruspea::Language
  class Core < Ruspea::Runtime::Env
    include Ruspea::Runtime

    def initialize(*args)
      super(*args)

      @ruby = Ruby.new
      @reader = Ruspea::Interpreter::Reader.new
      @evaler = Ruspea::Interpreter::Evaler.new

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
      Dir.glob(
        Ruspea.root.join("language/*.rsp").to_s
      ).each do |file|
        _, forms = @reader.call(
          File.read(file))
        @evaler.call(forms, context: self)
      end
    end

    def fn_quote
      Lmbd.new(
        params: [Sym.new("expression")],
        body: ->(env) {
          quote(env[Sym.new("expression")])
        }
      )
    end

    def quote(form)
      case
      when form.value.is_a?(Array)
        form.value
      when form.value.is_a?(List)
        form.value
      else
        form
      end
    end

    def fn_def
      @sym_sym ||= Sym.new("sym")
      @val_sym ||= Sym.new("val")
      @ctx_sym ||= Sym.new("%ctx")

      Lmbd.new(
        params: [@sym_sym, @val_sym],
        body: ->(env) {
          caller_context = env[@ctx_sym]
          sym = env[@sym_sym].value
          value_form = env[@val_sym]
          value = @evaler.call(value_form, context: env)
          caller_context[sym] = value
        }
      )
    end

    def fn_fn
      @params_sym ||= Sym.new("params")
      @body_sym ||= Sym.new("body")
      @ctx_sym ||= Sym.new("%ctx")

      fn = Fn.new
      fn.add(
        Lmbd.new(
          params: [@params_sym, @body_sym],
          body: ->(env) {
            params = quote(env[@params_sym])
            body = quote(env[@body_sym])
            closure = env[@ctx_sym]

            Lmbd.new(params: params, body: ->(fn_env) {
              @evaler.call(body, context: fn_env.fallback(closure))
            })
          }
        )
      )
    end

    def fn_cond
      Lmbd.new(
        params: [Sym.new("tuples")],
        body: ->(env) {
          conditions = env[Sym.new("tuples")]
          find_true(conditions, env)
        }
      )
    end

    def find_true(conditions, context)
      return nil if conditions.empty?
      tuple = conditions.head.value

      raise "NOPE: what is the expression?" if tuple.tail.empty?

      if @evaler.call(tuple.head, context: context) == true
        tuple.tail.to_a.reduce(nil) { |result, form|
          @evaler.call(form, context: context)
        }
      else
        find_true(conditions.tail, context)
      end
    end

    def fn_dot
      @path_sym ||= Sym.new("path")
      @ctx_sym ||= Sym.new("%ctx")

      Lmbd.new(
        params: [@path_sym],
        body: ->(env) {
          context = env.lookup(@ctx_sym)
          path = env.lookup(@path_sym)
        }
      )
      # Lm.new(
      #   params: [Sym.new("path")],
      #   body: ->(env, evaler) {
      #     context = env.lookup(Sym.new("%ctx"))
      #     path = env.lookup(Sym.new("path"))

      #     target =
      #       begin
      #         evaler.call(path.head, context: context)
      #       rescue Ruspea::Error::Resolution
      #         # if form is a symbol not solvable in the current context,
      #         # then we use it as the name of the "contantizable" thing.
      #         path.head.value.to_s
      #       end

      #     method = path.tail.head.value.to_s

      #     has_args = !path.tail.tail.empty?
      #     if has_args
      #       args = path.tail.tail
      #         .to_a
      #         .map { |form|
      #           evaler.call(form, context: context) }
      #       target.send(method, *args)
      #     else
      #       target.send(method)
      #     end
      #   }
      # )
    end

    def fn_constantize
      Lmbd.new(
        params: [Sym.new("path")],
        body: ->(env) {
          path = env[Sym.new("path")]
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
        Lmbd.new(
          params: [Sym.new("forms")],
          body: ->(env) {
            forms = @evaler.call(
              env[Sym.new("forms")], context: env)
            forms.reduce(nil) { |_, form|
              @evaler.call(form, context: env)
            }
          }
        )
      ).add(
        Lmbd.new(
          params: [Sym.new("forms"), Sym.new("context")],
          body: ->(env) {
            context = @evaler.call(
                env[Sym.new("context")], context: env)

            forms = @evaler.call(
              env[Sym.new("forms")], context: env)

            forms.reduce(nil) { |_, form|
              @evaler.call(form, context: context)
            }
          }
        )
      )
    end
  end
end
