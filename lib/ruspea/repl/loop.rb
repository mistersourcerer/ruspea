module Ruspea
  class Repl::Loop
    def initialize
      @reader = Reader.new
      @evaler = Evaler.new
      @printer = Printer.new

      @env = Runtime::Env.new
    end

    def run(input: STDIN)
      trap "SIGINT" do
        puts "See you soon."
        exit(130)
      end

      prompt_back

      while(line = input.gets)
        begin
          code = line.chomp

          while(code.length > 0)
            form, code, _ = @reader.next(code)
            result = @evaler.call(form, @env)
            @printer.print result
            print "\n"
          end
          prompt_back
        rescue Error::Standard => e
          print_error e
        rescue StandardError => e
          puts "A Ruby exception was raised. Inspect it? Y/n"
          yes = !["n", "no"].include?(input.gets.chomp.downcase)
          if yes
            puts "Error: #{e.message}\nBacktrace:\n"
            puts "\s\s#{e.backtrace.join("\n\s\s")}"
          end
          prompt_back
        end
      end

      puts "See you soon."
    end

    private

    def prompt_back(ns: "#user")
      puts ""
      print "#{ns}=> "
    end

    def print_error(e)
      puts e.class
      puts e.message
      prompt_back
    end
  end
end
