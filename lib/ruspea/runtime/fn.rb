module Ruspea::Runtime
  class Fn
    def initialize(*lambdas)
      @arities = {}

      lambdas.each { |lm| add lm }
    end

    def add(lm)
      arities[lm.arity] = lm
      self
    end

    def call(*args)
      arities
        .fetch(args.length)
        .call(*args)
    end

    private

    attr_reader :arities
  end
end
