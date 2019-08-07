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
      @should_exit = false
    end

    def run(input: $stdin, evaler: nil, env: Ruspea::Language::User.new)
      env.define Ruspea::Runtime::Sym.new("bye"), ->(*args) {
        @should_exit = true
      }

      evaler ||= @evaler
      @printer.print "#user=> "

      while(line = input.gets&.chomp)
        begin
          evaluate line, evaler, env
          break if @should_exit
          prompt_back
        rescue Ruspea::Error::Standard => e
          print_error e
        end
      end

      @printer.puts "See you soon."
    end

    private

    def evaluate(line, evaler, env)
      @reader.call(line).each do |form|
        expression = evaler.call(form, env: env)
        break if @should_exit
        @printer.call expression
      end
    end

    def prompt_back(ns: "#user")
      @printer.puts ""
      @printer.print "#{ns}=> "
    end

    def print_error(e)
      @printer.puts e.class
      @printer.puts e.message
      prompt_back
    end
  end
end
