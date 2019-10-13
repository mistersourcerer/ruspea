# RubyVM::InstructionSequence.compile_option = {
#   :tailcall_optimization => true,
#   :trace_instruction => false
# }

module Ruspea::Interpreter
  class Reader
    include Ruspea::Runtime
    include Ruspea::Error
    include Ruspea::Interpreter::Forms

    FORMS = [
      Hifen.new,
      Separator.new,
      String.new,
      Digit.new,
      List.new,
      Array.new,
      Quote.new,
      Symbol.new,
    ]

    def call(source, forms = [])
      return [source, forms] if source.empty?

      code = to_list(source)
      rest, new_form = next_form(code)
      new_forms = new_form.nil? ? forms : forms + [new_form]
      call(rest, new_forms)
    end

    def next_form(code)
      if_not_found = -> { raise "unrecognizable" }

      matcher = FORMS.find(if_not_found) { |matcher|
        matcher.match?(code.head)
      }

      matcher.read(code)
    end

    private

    def to_list(source)
      return source if source.is_a?(Ruspea::Runtime::List)

      Ruspea::Runtime::List.create(*source.chars)
    end
  end
end
