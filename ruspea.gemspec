require_relative "lib/ruspea/version"

Gem::Specification.new do |spec|
  spec.name          = "ruspea_lang"
  spec.version       = Ruspea::VERSION
  spec.authors       = ["Ricardo Valeriano"]
  spec.email         = ["mister.sourcerer@gmail.com"]

  spec.summary       = %q{A full featured lisp to be used as a Ruby Library (written in Ruby)}
  spec.description   = %q{A full featured lisp to be used as a Ruby Library (written in Ruby)}
  spec.homepage      = "https://github.com/mistersourcerer/ruspea"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.0.1")

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.2"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.10"

  spec.add_dependency "fiddle"
  spec.add_dependency "immutable-ruby"
  spec.add_dependency "logger"
  spec.add_dependency "ostruct"
  spec.add_dependency "zeitwerk"
end
