module Ruspea::Repl
  class ReplEnv < Ruspea::Runtime::Env
    def initialize(context = Ruspea::Language::Core.new, *args)
      super(context, args[1..args.length])
      @should_exit = false
    end

    def should_exit?
      @should_exit
    end
  end

  class Loop
    include Ruspea::Interpreter

    def initialize
      @reader = Reader.new
      @evaler = Evaler.new
      @printer = Ruspea::Printer.new
    end

    def run(input: STDIN, env: ReplEnv.new)
      prompt_back

      while(line = input.gets.chomp)
        begin
          break if env.respond_to?(:should_exit?) && env.should_exit?
          _, forms = @reader.call(line)
          forms.each do |expression|
            result = @evaler.call(expression, context: env)
            print @printer.call(result)
          end

          prompt_back
        rescue Ruspea::Error::Standard => e
          print_error e
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
