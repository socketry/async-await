# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2017-2024, by Samuel Williams.

require 'async/await'

describe Async::Await do
	include Async::Await
	
	async def find_chicken(*areas)
		sleep(rand)
		
		return areas.sample
	end
	
	it "should find some chickens" do
		result = find_chicken("house").wait
		
		expect(result).to be == "house"
	end
end
