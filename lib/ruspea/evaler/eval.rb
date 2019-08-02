module Ruspea::Evaler
  class Eval
    include Ruspea::Runtime

    def initialize
      @lisp = Ruspea::Runtime::Lisp.new
    end

    def call(form, env: Env.new, lisp: nil)
      lisp ||= @lisp

      case form
      when List
        invoke(form, env: env, lisp: lisp)
      when Sym
        form = env.lookup form
      else
        form
      end
    end

    private

    def invoke(form, env:, lisp:)
      fn = form.head
      native_function = lisp.respond_to? fn.to_s
      if native_function
        lisp.public_send fn.to_s, form.tail, env: env
      else
        env.lookup(fn).call(form.tail)
      end
    end
  end
end
