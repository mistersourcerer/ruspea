module Ruspea::Interpreter::Matchers
  class Map < Collection["{", "}"]
    def read(code, position = Position::INITIAL)
      elements, remaining, new_position = read_collection(code, position) { |form|
        !form.is_a?(Ruspea::Forms::Separator)
      }
      tuples = elements.each_slice(2).to_a

      validate_format(tuples, position)

      [
        Ruspea::Forms::Map.new(Hash[tuples], position),
        remaining[1..remaining.length],
        new_position + 1]
    end

    private

    class WrongFormat < StandardError
      def initialize(position)
        msg = <<~s
          Wrong number of forms #{position}.

          Maps are formed by keywords: followed by values.
        s

        super(msg)
      end
    end

    def validate_format(tuples, position)
      if tuples.any? { |tuple| tuple.length % 2 != 0 }
        raise WrongFormat.new(position)
      end
    end
  end
end
