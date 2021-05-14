require "forwardable"
module Ruspea
  class Core::Context
    extend Forwardable

    FALLBACK = Core::Environment.new

    def initialize(evaluator, fallback = FALLBACK)
      @evaluator = evaluator
      @fallback = fallback
      @env = Core::Environment.new
    end

    def eval(expr)
      evaluator.eval(expr, self)
    end

    def [](label)
      return env[label] if env.bound?(label)
      fallback[label]
    end

    def bound?(label)
      env.bound?(label) || fallback.bound?(label)
    end

    def_delegator :env, :[]=, :[]=

    private

    attr_reader :evaluator, :fallback, :env
  end
end
