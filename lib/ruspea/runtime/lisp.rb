module Ruspea::Runtime
  class Lisp
    def cons(el, list)
      list.cons(el)
    end

    # TODO: can we write it in a TCO friendly manner?
    def take(n, list)
      return Empty.instance if list.empty? || n == 0

      cons(list.head, take(n - 1, list.tail))
    end

    def empty?(list)
      list.empty?
    end

    def quote(params, env: nil)
      params.head
    end

    def def(params, env:)
      env.define params.head, params.tail.head
    end
  end
end
