module Ruspea::Repl
  class Loop
    def initialize(
      reader: Ruspea::Reader::Read.new,
      evaler: Ruspea::Evaler::Eval.new,
      printer: Ruspea::Printer::Print.new
    )
      @reader = reader
      @evaler = evaler
      @printer = printer
    end

    def run(input: $stdin, evaler: nil, env: Ruspea::Language::User.new)
      should_exit = false
      env.define Ruspea::Runtime::Sym.new("bye"), ->(*args) {
        should_exit = true
      }

      evaler ||= @evaler
      @printer.print "#user=> "
      while(line = input.gets&.chomp)
        break if should_exit

        begin
          @reader.call(line).each do |form|
            @printer.call evaler.call(form, env: env)
          end
          @printer.puts ""
          @printer.print "#user=> "
        rescue Ruspea::Error::Standard => e
          @printer.puts e.class
          @printer.puts e.message
          @printer.puts ""
          @printer.print "#user=> "
        end
      end

      @printer.puts "See you soon."
    end
  end
end
