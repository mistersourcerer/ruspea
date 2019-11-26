module Ruspea
  class Reader::Matchers::Collection
    def self.[](open_delimiter, close_delimiter)
      @@klasses ||= {}

      @@klasses.fetch(close_delimiter) {
        @@klasses[close_delimiter] = Class.new(Reader::Matchers::Collection).tap { |klass|
          klass.define_method(:open_delimiter) {
            open_delimiter
          }

          klass.define_method(:close_delimiter) {
            close_delimiter
          }
        }
      }
    end

    def match?(code)
      code[0] == open_delimiter
    end

    private

    def read_collection(code, position, &filter)
      reader = Ruspea::Reader.new
      new_position = position + 1
      remaining = code[1..code.length]
      filter ||= ->(_) { true }
      forms = []

      while(remaining[0] != close_delimiter)
        if remaining.length == 0
          raise "Expected collection starting on #{position} to be closed with '#{close_delimiter}'"
        end

        form, remaining, new_position = reader.next(remaining, new_position)
        forms = forms + [form] if filter.call(form)
      end

      [forms, remaining, new_position]
    end
  end
end
