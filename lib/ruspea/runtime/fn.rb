module Ruspea::Runtime
  class Fn
    def initialize(*lambdas)
      @arities = {}

      lambdas.each { |lm| add lm }
    end

    def add(lm)
      arities[lm.arity] = lm
    end

    def call(*args, context: nil, evaler: nil)
      arities
        .fetch(args.length)
        .call(*args, context: context, evaler: evaler)
    end

    private

    attr_reader :arities
  end
end
