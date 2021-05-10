module Ruspea
  class Core::Callable
    def initialize(params, body = [], evaler)
      @params = params
      @body = body
      @evaler = evaler
    end

    def arity
      params.count
    end

    def call(*args)
      # Now we need to find a way to pass
      # a new context (that will be created here)
      # back to the @evaler
    end

    private

    attr_reader :params, :body, :evaler
  end
end
