# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2025, by Samuel Williams.

require "async"

module Async
	module Await
		module Enumerable
			def async_map(parent: nil, &block)
				Sync do |task|
					parent ||= task
					
					self.map do |*arguments|
						parent.async(finished: false) do
							yield(*arguments)
						end
					end.map(&:wait)
				end
			end
			
			def async_each(parent: nil, &block)
				Sync do |task|
					parent ||= task
					
					self.each do |*arguments|
						parent.async do
							yield(*arguments)
						end
					end
				end
				
				return self
			end
		end
	end
end

::Enumerable.include(Async::Await::Enumerable)
