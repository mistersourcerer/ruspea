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
      evaler ||= @evaler
      while(line = input.gets&.chomp)
        begin
          # TODO: replace special treatment by normal function eval
          break if line == "(bye)"

          forms = @reader.call(line)
          forms.each do |form|
            @printer.call evaler.call(form, env: env)
          end
          @printer.puts ""
        rescue Ruspea::Error::Standard => e
          @printer.puts e.class
          @printer.puts e.message
        end
      end

      @printer.puts "See you soon."
    end
  end
end
