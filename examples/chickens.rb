# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2018-2024, by Samuel Williams.

require_relative '../lib/async/await'

class Coop
	include Async::Await
	
	async def count_chickens(area_name)
		3.times do |i|
			sleep rand
			
			puts "Found a chicken in the #{area_name}!"
		end
	end

	async def find_chicken(areas)
		puts "Searching for chicken..."
		
		sleep rand * 5
		
		return areas.sample
	end

	async def count_all_chickens
		# These methods all run at the same time.
		count_chickens("garden")
		count_chickens("house")
		count_chickens("tree")
		
		# Wait for all previous async work to complete...
		barrier!
		
		puts "There was a chicken in the #{find_chicken(["garden", "house", "tree"]).wait}"
	end
end

coop = Coop.new
coop.count_all_chickens
