# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2017-2025, by Samuel Williams.

require_relative "await/version"

# @namespace
module Async
	# Provide a way to wrap methods so that they can be run synchronously or asynchronously in an event loop.
	module Await
		# A hook that is called when the module is included in a class in order to provide the class with the methods defined in this module.
		def self.included(klass)
			klass.extend(self)
		end
		
		# Wrap the method with the given name in a block that will run the method synchronously in an event loop.
		#
		# @parameter name [Symbol] The name of the method to wrap.
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
			
			return name
		end
		
		# Wrap the method with the given name in a block that will run the method asynchronously in an event loop.
		#
		# @parameter name [Symbol] The name of the method to wrap.
		def async(name)
			original_method = instance_method(name)
			
			remove_method(name)
			
			define_method(name) do |*arguments, &block|
				Async::Reactor.run do |task|
					original_method.bind(self).call(*arguments, &block)
				end
			end
			
			return name
		end
	end
end
