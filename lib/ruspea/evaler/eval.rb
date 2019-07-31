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
        nil
      else
        form
      end
    end

    private

    def invoke(form, env:, lisp:)
      fn = form.head
      if lisp.respond_to? fn.to_s
        # TODO: Not sure about this if =(((
        params = form.tail.count > 1 ? List.create(form.tail) : form.tail
        lisp.public_send fn.to_s, params, env: env
      end
    end
  end
end
