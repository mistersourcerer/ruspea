module Ruspea::Language
  class Rsp < Ruspea::Runtime::Env
    include Ruspea::Runtime

    def initialize
      super

      define Sym.new("."), interop
    end

    private

    def interop
      @interop ||= ->(list, invocation_context: Env.new(self)) {
        _interop ||= Ruspea::Language::Interop.new
        _interop.call list, invocation_context: invocation_context
      }
    end
  end
end
