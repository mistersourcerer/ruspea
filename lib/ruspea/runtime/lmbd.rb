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

    def call(*args_list, context: nil)
      args = List.create(*args_list)
      check_arity(args)
      env = Env.new(context)
      env[Sym.new("%ctx")] = context if !context.nil?
      @body.call bind_arguments(env, args)
    end

    private

    VARARGS_REGEX = /\A\*.+/

    def check_arity(args)
      if !var_args? && args.count != arity
        raise Ruspea::Error::Arity.new(arity, args.count)
      end

      if var_args?
        if args.count < @params.length
          raise Ruspea::Error::ArityVarargs.new(arity, args.count)
        end
      end
    end

    def var_args?
      @var_args ||= @params.find { |param|
        param.match?(VARARGS_REGEX)
      }
    end

    def bind_arguments(env, args, pos = 0)
      return env if args.empty?

      if @params[pos].match?(VARARGS_REGEX)
        original_name = @params[pos].to_s
        varargs = Sym.new(original_name[1..original_name.length])

        # if varargs is in the middle of the argument list,
        # then we need to grab all of arguments until
        # the next one
        remaining = @params[(pos + 1)..@params.length]
        if remaining.length > 0
          to_take = args.count - remaining.length
          # TODO: what if there is a mismatch in here?
          # Meaning: to_take is 0 or less?
          # Then we raise...
          varargs_to_bind, remaining_args = args.take_and_rest(to_take)
          env[varargs] = varargs_to_bind.to_a.reverse
          return bind_arguments(env, remaining_args, pos + 1)
        else
          env[varargs] = args.to_a
          return env
        end
      end

      env[@params[pos]] = args.head
      bind_arguments(env, args.tail, pos + 1)
    end
  end
end
