module Ruspea::Interpreter::Matchers
  class Map < Collection["{", "}"]
    class WrongFormat < StandardError
      def initialize(position)
        msg = <<~s
          Wrong number of forms #{position}.

          Maps are formed by keywords: followed by values.
        s

        super(msg)
      end
    end

    def read(code, position = Position::INITIAL)
      elements, remaining, new_position = read_collection(code, position)

      tuples = elements
        .reject { |form| form.is_a?(Ruspea::Interpreter::Forms::Separator) }
        .each_slice(2)
        .to_a

      wrong_format = (tuples.any? { |tuple| tuple.length % 2 != 0 })
      raise WrongFormat.new(position) if wrong_format

      [
        Ruspea::Interpreter::Forms::Map.new(Hash[tuples], position),
        remaining[1..remaining.length],
        new_position + 1]
    end
  end
end
