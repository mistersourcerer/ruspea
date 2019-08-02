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
      # TODO: Not sure about this if
      if params.count == 1
        params.head
      else
        params
      end
    end

    def def(params, env:)
      env.define params.head, params.tail.head
    end

    def fn(params, env: nil)
      fn_params = params.head # check if it is array
      body = params.tail.to_a

      Fn.new(body, params: fn_params, context: env)
    end
  end
end
