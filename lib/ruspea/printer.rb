module Ruspea
  class Printer
    def call(value)
      MATCHERS.fetch(value.class) {
        value.class.include?(Form) ? FormPrinter.new(self) : GenericPrinter.new
      }.print(value)
    end

    private

    class GenericPrinter
      def print(value)
        value.to_s
      end
    end

    class FormPrinter
      def initialize(printer)
        @printer = printer
      end

      def print(form)
        @printer.call(form.value)
      end
    end

    MATCHERS = {
      Symbol => "Keyword",
      String => "String",
      Forms::Symbol => "Symbol",
      Runtime::List => "List",
      Runtime::Nil => "List",
      NilClass => "Nil",
    }.map { |type, class_name|
      [type, const_get("Ruspea::Printer::Matchers::#{class_name}").new]
    }.to_h
  end
end
