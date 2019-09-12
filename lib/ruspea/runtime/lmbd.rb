module Ruspea::Runtime
  class Lmbd
    def initialize(params: [], body: nil, &callable_body)
      @params = params
      @body =
        if block_given?
          callable_body
        else
          body
        end

      raise "All lambdas need a body! Maybe body: ->{}?" if @body.nil?
    end

    def arity
      @arity ||= @params.length
    end

    def call(*args)
      if args.length != arity
        raise Ruspea::Error::Arity.new(arity, args.length)
      end

      env = Env.new
      @params.each_with_index { |param, idx|
        env[param] = args[idx]
      }

      @body.call env
    end
  end
end
