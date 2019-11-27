module Ruspea
  class Runtime::Map
    def initialize(hsh = EMPTY)
      @hsh = hsh
    end

    def put(key, value)
      self.class.new(hsh.merge({key => value}))
    end

    def get(key)
      @hsh[key]
    end

    def eql?(other)
      self == other
    end

    def ==(other)
      if other.is_a?(self.class) &&
          other.hsh == self.hsh

        return true
      end

      false
    end

    def hash
      value.hash
    end

    def to_h
      hsh.dup
    end

    protected

    attr_reader :hsh

    private

    EMPTY = {}.freeze
  end
end
