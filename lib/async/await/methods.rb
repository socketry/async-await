# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2018-2024, by Samuel Williams.

require 'async/reactor'

require 'forwardable'

module Async
	module Await
		module Methods
			extend Forwardable

			def task
				Async::Task.current
			end

			def_delegators :task, :with_timeout, :sleep, :async

			def await(&block)
				block.call.wait
			end

			def barrier!
				task.children.each(&:wait)
			end
		end
	end
end
