# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2025, by Samuel Williams.

require "async"

module Async
	module Await
		# Provide asynchronous methods for enumerables.
		module Enumerable
			# This method is used to map the elements of an enumerable collection asynchronously.
			#
			# @parameter parent [Interface(:async)] The parent to use for creating new tasks.
			# @yields {|item| ...} The block to execute for each element in the collection.
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
			
			# This method is used to iterate over the elements of an enumerable collection asynchronously.
			#
			# @parameter parent [Interface(:async)] The parent to use for creating new tasks.
			# @yields {|item| ...} The block to execute for each element in the collection.
			# @return [self] The original enumerable collection.
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
