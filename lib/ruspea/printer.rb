module Ruspea
  class Printer
    def print(value)
      MATCHERS.fetch(value.class) { GenericPrinter.new }
    end

    private

    class GenericPrinter
      def print(value)
        value.to_s
      end
    end

    MATCHERS = {
      Symbol => "Keyword",
      # String => "String",
      # Form::Symbol => "Symbol",
    }.map { |type, class_name|
      [type, const_get("Ruspea::Printer::Matchers::#{class_name}").new]
    }.to_h
  end
end
