module Ruspea::Reader
  class Read
    include Ruspea::Runtime
    include Ruspea::Error

    def call(source, forms = [], open: nil)
      return forms if source.length == 0

      new_forms, remaining_source = new_form_from(source, open: open)

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
    CLOSING_DELIMITER = /\A[\)\]\}]/
    QUOTER = /\A'/
    DIGIT = /\A[\d-]/
    NUMERIC = /\A[\d_\.]/
    TOKEN_LIMIT = Regexp.union(SEPARATOR, CLOSING_DELIMITER)
    KEYWORD = /:\z/

    def new_form_from(source, token = "", open: nil)
      return [form_for(token), ""] if source.length == 0

      if !open.nil?
        tupple =
          case
          when open[:type] == String
            read_string(source, open[:tokens].first)
          when open[:type] == Array
            read_array(source, open[:tokens])
          when open[:type] == List
            read_list(source, open[:tokens])
          end

        return tupple
      end

      case source[0]
      when SEPARATOR
        [form_for(token), ignore_separators(source)]
      when CLOSING_DELIMITER
        [form_for(token), source]
      when "("
        read_list(source[1..source.length])
      when "'"
        next_form, new_source = new_form_from(source[1..source.length], "")
        [quote(next_form), new_source]
      when DIGIT
        read_numeric(source[1..source.length], source[0])
      when "\""
        read_string(source[1..source.length])
      when "["
        read_array(source[1..source.length])
      when "{"
        read_hash(source[1..source.length])
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
      KEYWORD.match?(token) ? Keyword.new(token) : Sym.new(token)
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
        return [List.create(*new_forms), new_source[1..new_source.length]]
      end

      read_list(new_source, new_forms)
    end

    def quote(form)
      @quote ||= Sym.new("quote")
      List.create(@quote, form)
    end

    def read_numeric(source, number, float: false)
      if source.length == 0 || TOKEN_LIMIT.match?(source[0])
        value =
          if number == "-"
            @hyfen ||= Sym.new("-")
          else
            float ? Float(number) : Integer(number)
          end

        return [value, source]
      end

      now_float, new_number, new_source =
        if source[0] == "."
          if float
            raise Syntax.new("Invalid number: #{number + source[0]}(...)")
          else
            [true, number + ".", source[1..source.length]]
          end
        else
          [float, number, source]
        end

      if !NUMERIC.match?(new_source[0])
        raise Syntax.new("Invalid number: #{number + source[0]}(...)")
      end

      read_numeric(
        new_source[1..new_source.length],
        new_number + new_source[0],
        float: now_float
      )
    end

    def read_string(source, string = "")
      return [string, source[1..source.length]] if source[0] == "\""

      if source.length == 0
        return [
          {
            type: String,
            tokens: [string],
            closed: false,
          }, ""]
      end

      read_string(source[1..source.length], string + source[0])
    end

    def read_array(source, elements = [])
      if source.length == 0
        return [
          {
            type: Array,
            tokens: elements,
            closed: false,
          }, ""]
      end

      new_form, new_source = new_form_from(source)
      new_elements = new_form.nil? ? elements : elements + [new_form]

      if new_source[0] == "]"
        return [new_elements, new_source[1..new_source.length]]
      end

      read_array(new_source, new_elements)
    end

    def read_hash(source, elements = [])
      if source.length == 0
        return [
          {
            type: Array,
            tokens: elements,
            closed: false,
          }, ""]
      end

      new_form, new_source = new_form_from(source)
      new_elements = new_form.nil? ? elements : elements + [new_form]

      if new_source[0] == "}"
        if (new_elements.length % 2) != 0
          raise Syntax.new("Map must contain an even number of forms")
        end

        return [Hash[*new_elements], new_source[1..new_source.length]]
      end

      read_hash(new_source, new_elements)
    end
  end
end