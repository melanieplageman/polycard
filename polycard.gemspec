require_relative 'lib/polycard/version'

Gem::Specification.new do |spec|
  spec.name          = "polycard"
  spec.version       = Polycard::VERSION
  spec.authors       = ["Melanie Plageman"]
  spec.email         = ["melanieplageman@gmail.com"]

  spec.summary       = %q{Make flashcards}
  spec.homepage      = "https://github.com/melanieplageman/flashcards"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/melanieplageman/flashcards"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rack" 
  spec.add_development_dependency "rack-test" 
  spec.add_development_dependency 'pry'

  spec.add_runtime_dependency 'sinatra'
  spec.add_runtime_dependency 'http'
  spec.add_runtime_dependency 'sequel'
  spec.add_runtime_dependency 'pg'
end
