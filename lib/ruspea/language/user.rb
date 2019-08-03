module Ruspea::Language
  # TODO: This is (should be) actually a namespace... 
  class User < ::Ruspea::Runtime::Env
    def initialize
      super ::Ruspea::Runtime::Env.new(Rsp.new)
    end
  end
end
