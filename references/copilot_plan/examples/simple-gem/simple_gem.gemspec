require_relative "lib/simple_gem/version"

Gem::Specification.new do |spec|
  spec.name          = "simple_gem"
  spec.version       = SimpleGem::VERSION
  spec.authors       = ["Graduate Course"]
  spec.email         = ["course@university.edu"]

  spec.summary       = "A simple Ruby gem example for educational purposes"
  spec.description   = "This gem demonstrates the basic structure and functionality of a Ruby gem, including simple greeting methods and time-based greetings."
  spec.homepage      = "https://github.com/daddygongon/multi_scale_25f"
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end