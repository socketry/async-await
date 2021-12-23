source 'https://rubygems.org'

gemspec

group :maintenance, optional: true do
	gem "bake-modernize"
	gem "bake-gem"
end

group :development do
	gem 'async-io', '~> 1.4'
end
