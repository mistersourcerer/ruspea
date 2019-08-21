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
      when Lm
        print_fn(value)
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

    def print_fn(fn)
      params = fn.params.map { |param| call(param) }.join(" ")
      body =
        if fn.body.respond_to?(:call)
          "#- internal -#\n  #{fn.body.inspect}"
        else
          body = fn.body.map { |exp| call(exp) }.join("\n  ")
        end

      "(fn [#{params}]\n  #{body})"
    end
  end
end
