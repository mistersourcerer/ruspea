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
      _exit = ->(*args) { @should_exit = true }
      env.define Ruspea::Runtime::Sym.new("bye"), _exit
      env.define Ruspea::Runtime::Sym.new("exit"), _exit

      evaler ||= @evaler
      @printer.print "#user=> "

      input_reader = -> { input.gets }
      while(line = input_reader.call&.chomp)
        begin
          @reader.call(line).each do |form|
            expression = evaler.call(form, env: env)
            expressions = [expression]

            while waiting_delimiter?(expressions.first)
              @printer.print "#user?> "
              code = input_reader.call&.chomp
              next if code.length == 0

              new_forms = @reader.call code, open: expression
              expressions = new_forms.map do |new_form|
                evaler.call(new_form, env: env)
              end

              break if @should_exit

              if waiting_delimiter? expressions.first
                expression = expressions.first
                next
              end
            end

            break if @should_exit
            expressions.each_with_index { |exp, idx|
              @printer.print "\n" if idx > 0
              @printer.call exp
            }
          end

          break if @should_exit
          prompt_back
        rescue Ruspea::Error::Standard => e
          print_error e
        end
      end

      $stdout.puts "See you soon."
    end

    private

    def prompt_back(ns: "#user")
      @printer.puts ""
      @printer.print "#{ns}=> "
    end

    def print_error(e)
      @printer.puts e.class
      @printer.puts e.message
      prompt_back
    end

    def waiting_delimiter?(expression)
      expression.is_a?(Hash) &&
        expression.key?(:type) && expression[:closed] == false
    end

    def wait_for_delimiter(expression, ns: "#user")
      @printer.puts "#{ns}?> "
    end
  end
end
