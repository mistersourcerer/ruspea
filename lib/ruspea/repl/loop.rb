module Ruspea::Repl
  class Loop
    include Ruspea::Interpreter

    def initialize
      @reader = Reader.new
      @evaler = Evaler.new
      @printer = Ruspea::Printer.new
      @env = Ruspea::Runtime::Env.new(Ruspea::Language::Core.new)

      load_repl(@env)
    end

    def run(input: STDIN, env: nil)
      trap "SIGINT" do
        puts "See you soon."
        exit(130)
      end

      env ||= @env
      prompt_back

      while(line = input.gets)
        begin
          interprete(line.chomp, env)
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

    def load_repl(env)
      Dir.glob(
        File.expand_path("../*.rsp", __FILE__)).each do |file|
          puts "loading repl: #{Pathname.new(file).basename}"
          _, forms = @reader.call(File.read(file))
          @evaler.call(forms, context: env)
        end
      puts "repl loaded."
    end

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
        result = @evaler.call(expression, context: env)
        Process.kill("SIGINT", Process.pid) if should_exit?(env)
        print @printer.call(result)
      end
    end
  end
end
