module Ruspea
  module Lisp::Errors
    def arg_type_error(given)
      given ||= "'()"
      Error::Execution.new <<~ERR
        Argument should be a list, received #{given} instead
      ERR
    end

    def check_args(args, expected)
      if args.empty? || args.size != expected
        raise Error::Execution.new <<~ERR
          Wrong number of arguments: given #{args.size}, expected #{expected}
        ERR
      end
    end
  end
end

