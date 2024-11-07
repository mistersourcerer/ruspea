require "pathname"
require "zeitwerk"

module Ruspea
  def self.root
    Pathname.new __dir__
  end
end

loader = Zeitwerk::Loader.for_gem
loader.ignore("#{__dir__}/example.rb")
loader.ignore("#{__dir__}/ruspea_lang.rb")
loader.setup
