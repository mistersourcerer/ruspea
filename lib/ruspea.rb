require "ruspea"
require "pathname"
require "zeitwerk"
Zeitwerk::Loader.for_gem.setup

module Ruspea
  def self.root
    Pathname.new File.expand_path("../", __FILE__)
  end
end
