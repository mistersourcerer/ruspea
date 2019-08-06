module Ruspea::Printer
  class Print
    def call(form, output: $stdout)
      output.print printable(form)
    end

    def puts(str, output: $stdout)
      output.puts str
    end

    def print(str, output: $stdout)
      output.print str
    end

    def printable(form)
      printer =
        if form.respond_to? :print
          -> { form.print }
        else
          printer_for(form)
        end

      printer.call
    end

    private

    def printer_for(form)
      case form
      when String
        -> { form.inspect }
      when Numeric
        -> { form.inspect }
      when TrueClass
        -> { "yes" }
      when FalseClass
        -> { "no" }
      else
        Ruby.new(form)
      end
    end
  end
end
