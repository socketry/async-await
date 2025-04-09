#!/usr/bin/env ruby
# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2018, by Kent 'picat' Gruber.
# Copyright, 2018-2025, by Samuel Williams.

require "async/io"
require "async/semaphore"
require_relative "../../lib/async/await"

class PortScanner
	include Async::Await
	include Async::IO

	def initialize(host: "0.0.0.0", ports:, batch_size: 1024)
		@host      = host
		@ports     = ports
		@semaphore = Async::Semaphore.new(batch_size)
	end

	def scan_port(port, timeout)
		with_timeout(timeout) do
			address = Async::IO::Address.tcp(@host, port)
			peer = Socket.connect(address)
			puts "#{port} open"
			peer.close
		end
		rescue Errno::ECONNREFUSED
		# puts "#{port} closed"
		rescue Async::TimeoutError
			puts "#{port} timeout"
	end

	async def start(timeout = 1.0)
		@ports.map do |port|
			@semaphore.async do
				scan_port(port, timeout)
			end
		end.collect(&:result)
	end
end

limits = Process.getrlimit(Process::RLIMIT_NOFILE)
batch_size = [512, (limits.first * 0.9).ceil].min

scanner = PortScanner.new(host: "127.0.0.1", ports: Range.new(1, 65535), batch_size: batch_size)

scanner.start
