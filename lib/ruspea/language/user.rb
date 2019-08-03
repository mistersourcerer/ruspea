module Ruspea::Language
  # TODO: This is (should be) actually a namespace... 
  class User < ::Ruspea::Runtime::Env
    def initialize
      super Rsp.new
    end
  end
end
