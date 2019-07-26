module Ruspea::Repl
  class Loop
    def initialize
      @evaler = Ruspea::Evaler::Eval.new
      @printer = Printer.new
      @reader = Reader.new
    end

    def run(input: $stdin)
      while(line = input.gets.chomp)
        break if line == ".exit"
        forms = @reader.read(line)
        puts "-- #{@evaler.call(forms)}"
        forms.each do |form|
          @printer.print @evaler.call(form)
          # if form is closed: false
          # @printer.wait_for_input
        end
        @printer.puts ""

      end

      @printer.puts "See you soon."
    end
  end
end
