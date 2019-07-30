module Ruspea::Runtime
  class Lisp
    def cons(el, list)
      list.cons(el)
    end

    def empty?(list)
      list.empty?
    end

    def quote(params, env: nil)
      return params if params.count > 1

      params.head
    end

    def def(params, env:)
      env.define params.head, params.tail.head
    end
  end
end
