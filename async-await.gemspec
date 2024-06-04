# frozen_string_literal: true

require_relative "lib/async/await/version"

Gem::Specification.new do |spec|
	spec.name = "async-await"
	spec.version = Async::Await::VERSION
	
	spec.summary = "Implements the async/await pattern on top of async :)"
	spec.authors = ["Samuel Williams", "Kent 'picat' Gruber", "Olle Jonsson"]
	spec.license = "MIT"
	
	spec.cert_chain  = ['release.cert']
	spec.signing_key = File.expand_path('~/.gem/release.pem')
	
	spec.homepage = "https://github.com/socketry/async-await"
	
	spec.metadata = {
		"source_code_uri" => "https://github.com/socketry/async-await.git",
	}
	
	spec.files = Dir.glob(['{lib}/**/*', '*.md'], File::FNM_DOTMATCH, base: __dir__)
	
	spec.required_ruby_version = ">= 3.1"
	
	spec.add_dependency "async"
end
