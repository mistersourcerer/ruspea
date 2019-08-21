module Ruspea
  class Printer
    include Ruspea::Runtime

    def call(value)
      case value
      when String
        value.inspect
      when Numeric
        value.inspect
      when Sym
        value.to_s
      when List
        print_list(value)
      else
        value.inspect
      end
    end

    private

    def print_list(list)
      count = list.count

      printed = list
        .take(10)
        .to_a
        .map { |intern| call(intern) }
        .join(" ")

      if count > 10
        "(#{printed} ...) # count: #{count}"
      else
        "(#{printed})"
      end
    end
  end
end
