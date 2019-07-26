module Ruspea::Evaler
  include Ruspea::Runtime

  class Eval
    def call(form)
      return invoke(form) if form.is_a? Ruspea::Runtime::List
    end

    private

    def invoke(form)
      fn = form.head
      if respond_to? fn.to_s, true
        send fn.to_s, form.tail.head
      end
    end

    def quote(params)
      params
    end
  end
end
