module Ruspea::Reader
  class Read
    include Ruspea::Runtime
    include Lisp

    def call(source, expressions = [])
      return expressions if source.length == 0

      new_expressions, remaining_source = new_expression_from(source)

      current_expressions =
        if new_expressions.nil?
          expressions
        else
          expressions + [new_expressions]
        end

      call(remaining_source, current_expressions)
    end

    private

    SEPARATOR = /\A[\s,]/

    def new_expression_from(source)
      case source[0]
      when SEPARATOR
        [nil, ignore_separators(source)]
      when "("
        read_list(source[1..source.length])
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
      Sym.new(token)
    end

    def read_list(source, token = "", tokens = [])
      if source.length == 0
        new_tokens = token.length > 0 ? tokens + [form_for(token)] : tokens
        return [
          {
            type: List,
            tokens: new_tokens,
            closed: false,
          }, source]
      end

      if source[0] == ")"
        new_tokens = token.length > 0 ? tokens + [form_for(token)] : tokens
        return [
          {
            form: List.create(*new_tokens),
            closed: true
          }, source[1..source.length]]
      end

      new_source, new_token, new_tokens =
        if SEPARATOR.match?(source[0])
          [ignore_separators(source), "", tokens + [form_for(token)]]
        else
          [source[1..source.length], token + source[0], tokens]
        end

      read_list(new_source, new_token, new_tokens)
    end
  end
end
