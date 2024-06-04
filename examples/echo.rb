# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2018-2024, by Samuel Williams.

require_relative '../lib/async/await'

require 'async/io'
require 'async/io/tcp_socket'

require 'pry'

class Echo
	include Async::Await
	include Async::IO
	
	async def handle(peer, address)
		data = peer.gets
		peer.puts("#{data} #{Time.now}")
	ensure
		peer.close
	end
	
	async def server
		puts "Binding server..."
		server = TCPServer.new("127.0.0.1", 9009)
		
		handle(*server.accept)
	ensure
		server.close rescue nil
	end

	async def client
		puts "Client connecting..."
		client = TCPSocket.new("127.0.0.1", 9009)
		
		client.puts("Hello World!")
		response = client.gets
		
		puts "Server said: #{response}"
	ensure
		client.close rescue nil
	end

	async def run
		puts "Creating server..."
		server
		
		puts "Creating client..."
		client
		
		puts "Run returning..."
	end
end

puts "Starting echo..."
echo = Echo.new
echo.run
puts "Echo finished :)"
