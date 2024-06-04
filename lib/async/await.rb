# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2017-2024, by Samuel Williams.

require_relative 'await/version'
require_relative 'await/methods'

module Async
	module Await
		def self.included(klass)
			klass.include(Methods)
			klass.extend(self)
		end
		
		def sync(name)
			original_method = instance_method(name)
			
			remove_method(name)
			
			define_method(name) do |*arguments, &block|
				if task = Task.current?
					original_method.bind(self).call(*arguments, &block)
				else
					Async::Reactor.run do
						original_method.bind(self).call(*arguments, &block)
					end.wait
				end
			end
			
			ruby2_keywords(name)
		end
		
		def async(name)
			original_method = instance_method(name)
			
			remove_method(name)
			
			define_method(name) do |*arguments, &block|
				Async::Reactor.run do |task|
					original_method.bind(self).call(*arguments, &block)
				end
			end
		end
	end
end
