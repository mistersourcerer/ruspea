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

    def call(args_list, context: nil)
      if args_list.count != arity
        raise Ruspea::Error::Arity.new(arity, args_list.count)
      end

      env = Env.new(context)
      env[Sym.new("%ctx")] = context if !context.nil?
      @body.call bind_arguments(env, args_list)
    end

    def bind_arguments(env, args, pos = 0)
      return env if args.empty?

      env[@params[pos]] = args.head
      bind_arguments(env, args.tail, pos + 1)
    end
  end
end
