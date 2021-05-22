module Ruspea
  class Lisp::Lambda
    include Core::Predicates
    include Lisp::Errors

    def call(args, ctx)
      raise arg_type_error(args) if !list?(args)
      raise params_required_error if args.empty?
      raise params_required_error if !list?(args.head)
      if non_symbol = find(args.head) { |arg| !sym?(arg) }
        raise non_symbol_param_error(non_symbol)
      end

      Core::Function.new(args.head, args.tail.head, ctx)
    end

    def eval_args?
      false
    end

    private

    def find(list, &blk)
      return list.head if yield(list.head)
      return nil if list.empty?
      find(list.tail, &blk)
    end

    def params_required_error
      Error::Execution.new <<~ERR
        A lambda needs the parameters list.
        It might be empty, you can try: (lambda ())
      ERR
    end

    def non_symbol_param_error(non_symbol)
      Error::Execution.new <<~ERR
        Invalid parameter identifier.
        The element #{non_symbol} should be a Symbol
      ERR
    end
  end
end
