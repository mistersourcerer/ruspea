module Ruspea
  class Core::Callable
    def initialize(params, body, ctx, evaler)
      @params = params
      @body = body
      @ctx = ctx
      @evaler = evaler
    end

    def arity
      params.count
    end

    def call(*args, &evaler_blk)
      raise arity_error(arity, args.count) if arity != args.count
      (evaler_blk || evaler).call(body, invocation_ctx(args))
    end

    private

    attr_reader :params, :body, :evaler, :ctx

    def arity_error(expected, given)
      Ruspea::Error::Execution.new <<~ER
        Wrong number of args for #{caller_locations.first.label}, 
        expected #{expected} but #{given} given
      ER
    end

    def invocation_ctx(args)
      params
        .each_with_index
        .reduce(ctx.around(Core::Context.new)) { |ivk_ctx, (param, idx)|
          ivk_ctx.tap { |c| c[param] = args[idx] }
        }
    end
  end
end
