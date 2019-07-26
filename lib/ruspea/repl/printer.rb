module Ruspea::Repl
  class Printer
    def print(form, output: $stdout)
      if form.respond_to? :print
        output.print form.print
      else
        output.print "#{form} // Ruby.#{form.class}"
      end
    end

    def puts(str, output: $stdout)
      output.puts str
    end
  end
end
