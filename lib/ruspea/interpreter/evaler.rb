module Ruspea::Interpreter
  class Evaler
    include Ruspea::Runtime
    include Ruspea::Error

    def call(forms, context: Env::Empty.instance)
      Array(forms).reduce(nil) { |result, form|
        if form.respond_to?(:evaler) && !form.evaler.nil?
          form.eval(context, self)
        else
          raise "no evaler for #{form.value}"
        end
      }
    end
  end
end
