# frozen_string_literal: true

require_relative "lib/async/await/version"

Gem::Specification.new do |spec|
	spec.name = "async-await"
	spec.version = Async::Await::VERSION
	
	spec.summary = "Implements the async/await pattern on top of async :)"
	spec.authors = ["Samuel Williams"]
	spec.license = "MIT"
	
	spec.homepage = "https://github.com/socketry/async-await"
	
	spec.files = Dir.glob('{lib}/**/*', File::FNM_DOTMATCH, base: __dir__)
	
	spec.add_dependency "async"
	spec.add_dependency "ruby2_keywords"
	
	spec.add_development_dependency "async-rspec", "~> 1.1"
	spec.add_development_dependency "covered"
	spec.add_development_dependency "rspec", "~> 3.0"
end
