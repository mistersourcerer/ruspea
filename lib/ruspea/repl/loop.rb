module Ruspea::Repl
  class Loop
    def initialize(
      reader: Ruspea::Reader::Read.new,
      evaler: Ruspea::Evaler::Eval.new,
      printer: Printer.new
    )
      @reader = reader
      @evaler = evaler
      @printer = printer
    end

    def run(input: $stdin)
      while(line = input.gets.chomp)
        # TODO: replace special treatment by normal function eval
        break if line == "(bye)"

        forms = @reader.call(line)
        forms.each do |form|
          @printer.print @evaler.call(form)
        end
        @printer.puts ""

      end

      @printer.puts "See you soon."
    end
  end
end
