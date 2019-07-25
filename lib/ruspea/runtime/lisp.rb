module Ruspea::Runtime
  module Lisp
    def cons(el, list)
      list.cons(el)
    end

    def empty?(list)
      list.empty?
    end
  end
end
