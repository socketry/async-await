
require_relative '../lib/async/await'

class Sleepy
	include Async::Await
	
	async def sort_one(item, into)
		sleep(item)
		into << item
	end
	
	async def sort(items)
		result = []
		
		items.each do |item|
			sort_one(item, result)
		end
		
		barrier!
		
		return result
	end
end

puts "Hold on, sorting..."
sleepy = Sleepy.new
puts sleepy.sort([5, 2, 3, 4, 9, 2, 5, 7, 8]).result.inspect
