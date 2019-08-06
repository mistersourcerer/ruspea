require "readline"

module Ruspea::Repl
  class Loopr
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
      while(line = Readline.readline)
        begin
          # TODO: replace special treatment by normal function eval
          break if line == "(bye)"

          forms = @reader.call(line)
          forms.each do |form|
            @printer.call evaler.call(form, env: env)
          end
          @printer.puts ""

          p Readline::HISTORY.to_a
        rescue Ruspea::Error::Standard => e
          @printer.puts e.class
          @printer.puts e.message
        end
      end

      @printer.puts "See you soon."
    end
  end
end
