# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rapis/version'

Gem::Specification.new do |spec|
  spec.name          = "rapis"
  spec.version       = Rapis::VERSION
  spec.authors       = ["Masashi Terui"]
  spec.email         = ["marcy9114@gmail.com"]

  spec.summary       = %q{Swagger as Ruby DSL and its deployment tool for Amazon API Gateway}
  spec.description   = %q{Swagger as Ruby DSL and its deployment tool for Amazon API Gateway}
  spec.homepage      = "https://github.com/marcy-terui/rapis"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "aws-sdk", "~> 2.3.9"
  spec.add_dependency "dslh", "~> 0.3.8"
  spec.add_dependency "thor", "~> 0.19.1"
  spec.add_dependency "coderay"
  spec.add_dependency "diffy"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
