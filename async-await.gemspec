# coding: utf-8
require_relative "lib/async/await/version"

Gem::Specification.new do |spec|
	spec.name          = "async-await"
	spec.version       = Async::Await::VERSION
	spec.authors       = ["Samuel Williams"]
	spec.email         = ["samuel.williams@oriontransfer.co.nz"]

	spec.summary       = "Implements the async/await pattern on top of async :)"
	spec.homepage      = "https://github.com/socketry/async-await"

	spec.files         = `git ls-files -z`.split("\x0").reject do |f|
		f.match(%r{^(test|spec|features)/})
	end
	
	spec.require_paths = ["lib"]

	spec.add_dependency "async", "~> 1.0"
	spec.add_development_dependency "async-rspec", "~> 1.1"

	spec.add_development_dependency "bundler", "~> 1.15"
	spec.add_development_dependency "rake", "~> 10.0"
	spec.add_development_dependency "rspec", "~> 3.0"
end
