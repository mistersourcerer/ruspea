module Ruspea::Repl
  class Reader
    include Ruspea::Reader

    def read(code, reader: Read.new)
      reader.call code
    end
  end
end
