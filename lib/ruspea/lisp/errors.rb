module Ruspea
  module Lisp::Errors
    def arg_type_error(given)
      Error::Execution.new <<~ERR
        Argument should be a list with one element, received #{given} instead
      ERR
    end

    def args_error(given, expected)
      Error::Execution.new <<~ERR
        Wrong number of arguments: given #{given}, expected #{expected}
      ERR
    end
  end
end

