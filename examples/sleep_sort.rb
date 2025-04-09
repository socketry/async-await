# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2018-2025, by Samuel Williams.

require_relative "../lib/async/await"

class << self
	include Async::Await
	
	async def sort_one(item, into)
		sleep(item.to_f)
		into << item
		
		puts "I've sorted #{item} for you."
	end
	
	async def sort(items)
		result = []
		
		items.each do |item|
			sort_one(item, result)
		end
		
		# Wait until all previous async method calls have finished executing.
		barrier!
		
		return result
	end
end

puts "Hold on, sorting..."
puts sort([5, 2, 3, 4, 9, 2, 5, 7, 8]).result.inspect
