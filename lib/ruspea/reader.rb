module Ruspea
  class Reader
    include Ruspea::Forms

    def next(code, position = Position::INITIAL)
      @matchers ||= MATCHERS + [NoMatches.new]

      @matchers
        .find { |t| t.match?(code) }
        .read(code, position)
    end

    private

    class NoMatches
      def match?(_)
        true
      end

      def read(_, position)
        raise "No form was recognized at position #{position}."
      end
    end

    # The order of the matching is important.
    MATCHERS = [
      "Numeric", "String",
      "Array", "Map", "List",
      "Quote",
      "Line", "Separator",
      "Comment",
      "Symbol",
    ].map do |class_name|
      const_get("Ruspea::Reader::Matchers::#{class_name}").new
    end

    def code_to_forms(string)
      []
    end
  end
end
