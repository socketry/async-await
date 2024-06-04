# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020-2024, by Samuel Williams.

require 'async/await/enumerable'

describe Async::Await::Enumerable do
	it "should map values" do
		result = [1, 2, 3].async_map do |value|
			value * 2
		end
		
		expect(result).to be == [2, 4, 6]
	end
end
