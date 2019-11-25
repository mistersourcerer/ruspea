module Ruspea::Repl
  class Loop
    def initialize
      @reader = Ruspea::Interpreter::Reader.new
      @evaler = Ruspea::Interpreter::Evaler.new
      # @printer = Ruspea::Printer.new

      @env = Ruspea::Runtime::Env.new
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
            puts result
          end
          prompt_back
        rescue Ruspea::Error::Standard => e
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

    def should_exit?(env)
      env.call Ruspea::Runtime::Sym.new("%repl_should_exit?")
    rescue Ruspea::Error::Resolution
      false
    end

    def interprete(line, env)
      _, forms = @reader.call(line)
      forms.each do |expression|
        # puts "read: "
        # pp expression
        result = @evaler.call(expression, context: env)
        # puts "evaled: "
        # pp result
        Process.kill("SIGINT", Process.pid) if should_exit?(env)
        print @printer.call(result)
      end
    end
  end
end
