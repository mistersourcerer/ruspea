require "pathname"
require "zeitwerk"

module Ruspea
  def self.root
    Pathname.new __dir__
  end
end

loader = Zeitwerk::Loader.for_gem
loader.setup
