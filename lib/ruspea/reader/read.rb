module Ruspea::Reader
  class Read
    include Ruspea::Runtime
    include Lisp

    def call(source, forms = [])
      return forms if source.length == 0

      new_forms, remaining_source = new_form_from(source)

      current_forms =
        if new_forms.nil?
          forms
        else
          forms + [new_forms]
        end

      call(remaining_source, current_forms)
    end

    private

    SEPARATOR = /\A[\s,]/
    CLOSING_DELIMITER = /\A[\)]/

    def new_form_from(source, token = "")
      return [form_for(token), ""] if source.length == 0

      case source[0]
      when SEPARATOR
        [form_for(token), ignore_separators(source)]
      when CLOSING_DELIMITER
        [form_for(token), source]
      when "("
        read_list(source[1..source.length])
      else
        new_form_from(source[1..source.length], token + source[0])
      end
    end

    def ignore_separators(source)
      return if source.nil?

      if SEPARATOR.match?(source[0])
        ignore_separators source[1..source.length]
      else
        source
      end
    end

    def form_for(token)
      return if token.length == 0
      Sym.new(token)
    end

    def read_list(source, forms = [])
      if source.length == 0
        return [
          {
            type: List,
            tokens: forms,
            closed: false,
          }, source]
      end

      new_form, new_source = new_form_from(source)
      new_forms = new_form.nil? ? forms : forms + [new_form]

      if new_source[0] == ")"
        return [
          {
            form: List.create(*new_forms),
            closed: true
          }, new_source[1..new_source.length]]
      end

      read_list(new_source, new_forms)
    end
  end
end
