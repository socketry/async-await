
require_relative '../lib/async/await'

require 'async/io'
require 'async/io/tcp_socket'

class Echo
	include Async::Await
	include Async::IO
	
	async def handle(peer, address)
		data = peer.read(1024)
		peer.write("#{data} #{Time.now}")
	ensure
		peer.close
	end
	
	async def server
		puts "Binding server..."
		server = TCPServer.new(::TCPServer.new("127.0.0.1", 9009))
		
		handle(*server.accept)
	ensure
		server.close
	end

	async def client
		client = TCPSocket.new(::TCPSocket.new("127.0.0.1", 9009))
		
		client.write("Hello World!")
		response = client.read(1024)
		puts "Server said: #{response}"
	ensure
		client.close
	end

	async def run
		server
		client
	end
end

echo = Echo.new
echo.run
