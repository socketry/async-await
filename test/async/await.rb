# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2017-2024, by Samuel Williams.

require 'async/await'

class Coop
	include Async::Await
	
	async def find_chicken(areas)
		sleep(rand)
		return areas.sample
	end
	
	sync def find_chickens(count, areas)
		count.times.map do
			find_chicken(areas)
		end
	end
end

describe Async::Await do
	let(:coop) {Coop.new}
	
	it "can find async chicken" do
		result = coop.find_chicken(["house"]).wait
		
		expect(result).to be == "house"
	end
	
	it "can find several chickens" do
		result = coop.find_chickens(3, ["house", "yard"])
		
		expect(result).to have_attributes(size: be == 3)
	end
	
	it "can find several chickens in nested async" do
		Async do
			result = coop.find_chickens(3, ["house", "yard"])
			
			expect(result).to have_attributes(size: be == 3)
		end
	end
	
	with '#await' do
		
	end
end
