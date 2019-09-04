module Ruspea
  class Code
    def initialize
      @reader = Ruspea::Interpreter::Reader.new
      @evaler = Ruspea::Interpreter::Evaler.new
      @printer = Ruspea::Printer.new
    end

    def load(file_path)
      raise "#{file_path} is not a file" if !File.exists?(file_path)
      exec(File.read(file_path))
    end

    def run(code, env: Ruspea::Language::Core.new)
      _, forms = @reader.call(code)
      @evaler.call(forms, context: env)
    end
  end
end
