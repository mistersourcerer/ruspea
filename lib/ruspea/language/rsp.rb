module Ruspea::Language
  class Rsp < Ruspea::Runtime::Env
    include Ruspea::Runtime

    def initialize
      super

      define Sym.new("."), interop
    end

    private

    def interop
      @interop ||= ->(list, env: Env.new(self)) {
        _interop ||= Ruspea::Language::Interop.new
        _interop.call list
      }
    end
  end
end
