module Ruspea::Language
  class Rsp < Ruspea::Runtime::Env
    include Ruspea::Runtime

    def initialize(*args)
      super

      @evaler = Ruspea::Evaler::Eval.new
      @reader = Ruspea::Reader::Read.new

      define Sym.new("."), interop
      load_ruspea(Ruspea.root.join("language"))
    end

    private

    def interop
      @interop ||= ->(list, invocation_context: Env.new(self)) {
        _interop ||= Ruspea::Language::Interop.new
        _interop.call list, invocation_context: invocation_context
      }
    end

    def load_ruspea(rsp_lang_dir)
      Dir.glob("*.rsp", base: rsp_lang_dir) do |rsp_file|
        file = File.read(rsp_lang_dir.join(rsp_file))
        @reader.call(file).each { |form|
          @evaler.call form, env: self
        }
      end
    end
  end
end
